/* (C)2026 */
package com.github.lamarios.podku.recommendations;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastRepository;
import com.github.lamarios.podku.recommendations.EpisodeRecommendationsRepository.Keyword;
import com.github.lamarios.podku.recommendations.EpisodeRecommendationsRepository.LexemeCount;
import com.github.lamarios.podku.search.ItunesPodcastSearch;
import com.github.lamarios.podku.search.SearchResult;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.function.Supplier;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.data.domain.Limit;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/**
 * Recommends podcasts related to an episode.
 *
 * <p>The iTunes API has no "similar podcasts" endpoint, so recommendations are built in three
 * steps:
 *
 * <ol>
 *   <li>the most distinctive words of the episode (and of its podcast's description) are found with
 *       tf-idf over the library's episodes, in Postgres;
 *   <li>candidates are gathered from iTunes searches on these words and from the top podcasts of
 *       the podcast's iTunes genre;
 *   <li>each candidate's feed is read and the candidates are ranked by the cosine similarity
 *       between their text and the episode's keywords.
 * </ol>
 *
 * <p>This takes a few seconds and several iTunes calls (which are rate limited), so results are
 * cached per episode for {@link #CACHE_DURATION}.
 */
@Service
public class RecommendationService {
  private static final Logger log = LogManager.getLogger();

  static final Duration CACHE_DURATION = Duration.ofDays(7);
  private static final String COUNTRY = "US";

  /**
   * Number of keywords describing the episode, used to score the candidates. Many more than are
   * searched, so that broad topic words count, not only the most specific ones.
   */
  private static final int KEYWORD_COUNT = 100;

  /** Number of latest episode titles of the podcast added to the episode text, for context. */
  private static final int CONTEXT_TITLES = 20;

  /** Number of keywords that are searched on iTunes, one search each. */
  private static final int SEARCHED_KEYWORDS = 4;

  /** Results per keyword search, many are dropped for not sharing the podcast's genres. */
  private static final int RESULTS_PER_SEARCH = 25;

  private static final int CHART_SIZE = 50;
  private static final int MAX_CANDIDATES = 30;
  private static final int FEED_ITEMS = 10;

  /** Number of recommendations kept in cache, more than requested as subscriptions are removed. */
  private static final int STORED_RECOMMENDATIONS = 15;

  /**
   * Maximum number of recommendations coming from the same keyword search, so that one strong
   * keyword ("tesla") doesn't fill every slot. Genre chart candidates aren't capped.
   */
  private static final int MAX_PER_KEYWORD = 2;

  private static final String CHART_SOURCE = "";

  /** Boost given to a candidate sharing the primary genre of the episode's podcast. */
  private static final double SAME_GENRE_BOOST = 1.5;

  /** The generic "Podcasts" genre every podcast has. */
  private static final String PODCASTS_GENRE_ID = "26";

  private static final String PODCASTS_GENRE_NAME = "Podcasts";

  /** Words common to podcast descriptions that say nothing about their topic. */
  private static final String IGNORED_WORDS =
      """
      episode episodes podcast podcasts show shows listen listener listeners listening subscribe
      subscribers patreon sponsor sponsors sponsored support supporters ad ads advertising promo code
      offer discount free today week weekly daily host hosts hosted join welcome talk talks
      discuss discusses conversation interview guest guests special also new latest part http https
      www com org net email twitter instagram facebook youtube tiktok spotify apple itunes rss
      privacy policy info information visit website click link links learn get go check deal deals
      gift purchase purchases store compensation sweepstakes win order limited time save sale
      shipping coupon trial affiliate january february march april may june july august september
      october november december monday tuesday wednesday thursday friday saturday sunday
      """;

  /** Block level HTML tags, replaced by line breaks before splitting descriptions in paragraphs. */
  private static final Pattern BLOCK_TAGS =
      Pattern.compile("(?i)<\\s*(br|/p|p|/li|li|/div|div|h[1-6]|/h[1-6])\\b[^>]*>");

  private static final Pattern TAGS = Pattern.compile("<[^>]*>");

  /**
   * Paragraphs matching this are ads or links (sponsor reads, promo codes, socials), whose words
   * (brand names) would otherwise be the most distinctive ones of the episode.
   */
  private static final Pattern AD_PARAGRAPH =
      Pattern.compile(
          "(?i)(https?://|www\\.|\\.(com|net|org|io|fm|gg|ly)\\b|promo|\\b(use|with) code\\b|sponsor|"
              + "\\b(discount|coupon)\\b|% off)");

  private static final ExecutorService EXECUTOR = Executors.newVirtualThreadPerTaskExecutor();

  private final EpisodeRepository episodeRepository;
  private final PodcastRepository podcastRepository;
  private final EpisodeRecommendationsRepository recommendationsRepository;
  private final ItunesPodcastSearch itunes;
  private final FeedTextFetcher feedTextFetcher;
  private final ObjectMapper objectMapper = new ObjectMapper();

  /** Computations in progress, so concurrent requests for an episode only compute it once. */
  private final Map<UUID, CompletableFuture<List<SearchResult>>> inFlight =
      new ConcurrentHashMap<>();

  /**
   * Constructs the RecommendationService.
   *
   * @param episodeRepository episode repository
   * @param podcastRepository podcast repository, for the subscriptions to exclude
   * @param recommendationsRepository recommendation cache and text analysis queries
   * @param itunes iTunes API client
   * @param feedTextFetcher reads the candidates' feeds
   */
  public RecommendationService(
      EpisodeRepository episodeRepository,
      PodcastRepository podcastRepository,
      EpisodeRecommendationsRepository recommendationsRepository,
      ItunesPodcastSearch itunes,
      FeedTextFetcher feedTextFetcher) {
    this.episodeRepository = episodeRepository;
    this.podcastRepository = podcastRepository;
    this.recommendationsRepository = recommendationsRepository;
    this.itunes = itunes;
    this.feedTextFetcher = feedTextFetcher;
  }

  /**
   * Gets the podcasts recommended for an episode, excluding the subscribed ones. Computes them if
   * they aren't cached or the cache expired, which can take a few seconds.
   *
   * @param episodeId the episode
   * @param limit maximum number of recommendations
   * @return the recommendations, best match first
   * @throws ResponseStatusException 404 if the episode doesn't exist
   */
  public List<SearchResult> getRecommendations(UUID episodeId, int limit) {
    Episode episode =
        episodeRepository
            .findById(episodeId)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

    List<SearchResult> recommendations =
        recommendationsRepository
            .findById(episodeId)
            .filter(r -> r.getComputedAt().isAfter(Instant.now().minus(CACHE_DURATION)))
            .map(r -> fromJson(r.getResults()))
            .orElseGet(() -> computeOnce(episode));

    Set<String> subscribed =
        podcastRepository.findAllUrls().stream()
            .map(RecommendationService::normalizeUrl)
            .collect(Collectors.toSet());

    return recommendations.stream()
        .filter(r -> !subscribed.contains(normalizeUrl(r.getFeedUrl())))
        .limit(limit)
        .toList();
  }

  /**
   * Computes and caches the recommendations of an episode, sharing the computation with concurrent
   * requests for the same episode.
   *
   * @param episode the episode
   * @return the recommendations, best match first
   */
  private List<SearchResult> computeOnce(Episode episode) {
    CompletableFuture<List<SearchResult>> future =
        inFlight.computeIfAbsent(
            episode.getId(),
            _ -> CompletableFuture.supplyAsync(() -> computeAndStore(episode), EXECUTOR));
    future.whenComplete((_, _) -> inFlight.remove(episode.getId(), future));
    try {
      return future.join();
    } catch (CompletionException e) {
      if (e.getCause() instanceof RuntimeException cause) {
        throw cause;
      }
      throw e;
    }
  }

  /**
   * Computes the recommendations of an episode and stores them in cache.
   *
   * @param episode the episode
   * @return the recommendations, best match first
   */
  private List<SearchResult> computeAndStore(Episode episode) {
    long start = System.currentTimeMillis();
    List<SearchResult> recommendations = compute(episode);
    recommendationsRepository.save(
        new EpisodeRecommendations(episode.getId(), Instant.now(), toJson(recommendations)));
    log.info(
        "Computed {} recommendations for episode {} in {}ms",
        recommendations.size(),
        episode.getId(),
        System.currentTimeMillis() - start);
    return recommendations;
  }

  /**
   * Computes the recommendations of an episode.
   *
   * @param episode the episode
   * @return the recommendations, best match first, with their artwork colors
   */
  List<SearchResult> compute(Episode episode) {
    Podcast podcast = episode.getPodcast();
    List<String> latestTitles =
        episodeRepository.findLatestTitles(podcast.getId(), Limit.of(CONTEXT_TITLES));
    String sourceText = sourceText(episode, podcast, latestTitles);
    // the podcast's own name is mostly a brand ("The WAN Show"), searching it finds unrelated shows
    String ignored = IGNORED_WORDS + " " + Objects.toString(podcast.getName(), "");
    List<Keyword> keywords =
        recommendationsRepository.findKeywords(sourceText, ignored, KEYWORD_COUNT);
    if (keywords.isEmpty()) {
      log.info("No keywords found for episode {}, no recommendations", episode.getId());
      return List.of();
    }
    log.debug(
        "Keywords of episode {}: {}",
        episode.getId(),
        keywords.stream().map(Keyword::getToken).toList());

    Optional<SearchResult> itunesEntry = findItunesEntry(podcast);
    Collection<Candidate> candidates = gatherCandidates(podcast, keywords, itunesEntry);

    Map<String, Double> sourceVector =
        keywords.stream()
            .collect(Collectors.toMap(Keyword::getLexeme, Keyword::getWeight, (a, _) -> a));
    String primaryGenre = itunesEntry.map(SearchResult::getPrimaryGenreName).orElse(null);

    List<CompletableFuture<Optional<Scored>>> scoring =
        candidates.stream()
            .map(
                c ->
                    CompletableFuture.supplyAsync(
                        () -> score(c, sourceVector, primaryGenre), EXECUTOR))
            .toList();

    List<Scored> ranked =
        scoring.stream()
            .map(CompletableFuture::join)
            .flatMap(Optional::stream)
            .filter(s -> s.score() > 0)
            .sorted(Comparator.comparingDouble(Scored::score).reversed())
            .toList();

    return itunes.withColors(diversify(ranked));
  }

  /**
   * Keeps the best recommendations, with at most {@link #MAX_PER_KEYWORD} from each keyword search.
   *
   * @param ranked the scored candidates, best first
   * @return at most {@link #STORED_RECOMMENDATIONS} recommendations, best first
   */
  static List<SearchResult> diversify(List<Scored> ranked) {
    Map<String, Integer> perSource = new HashMap<>();
    List<SearchResult> best = new ArrayList<>();
    for (Scored scored : ranked) {
      if (best.size() >= STORED_RECOMMENDATIONS) {
        break;
      }
      String source = scored.candidate().source();
      int count = perSource.merge(source, 1, Integer::sum);
      if (source.equals(CHART_SOURCE) || count <= MAX_PER_KEYWORD) {
        best.add(scored.candidate().result());
      }
    }
    return best;
  }

  /**
   * Builds the text describing an episode: its title and description, its podcast's description and
   * the titles of the podcast's latest episodes, which give the podcast's general topic when the
   * episode's description is thin. Ads are removed from the descriptions.
   *
   * @param episode the episode
   * @param podcast the episode's podcast
   * @param latestTitles titles of the podcast's latest episodes
   * @return the text
   */
  static String sourceText(Episode episode, Podcast podcast, List<String> latestTitles) {
    List<String> parts = new ArrayList<>();
    parts.add(Objects.toString(episode.getTitle(), ""));
    parts.add(withoutAds(episode.getDescription()));
    parts.add(withoutAds(podcast.getDescription()));
    latestTitles.stream()
        .filter(t -> t != null && !t.equals(episode.getTitle()))
        .forEach(parts::add);
    return truncate(String.join("\n", parts));
  }

  /**
   * Removes the HTML and the paragraphs that look like ads or links from a description.
   *
   * @param description the description, may be null or HTML
   * @return the remaining text, one paragraph per line
   */
  static String withoutAds(String description) {
    if (description == null) {
      return "";
    }
    String text = TAGS.matcher(BLOCK_TAGS.matcher(description).replaceAll("\n")).replaceAll(" ");
    return text.lines()
        .map(String::strip)
        .filter(line -> !line.isEmpty() && !AD_PARAGRAPH.matcher(line).find())
        .collect(Collectors.joining("\n"));
  }

  /**
   * Truncates a text to what Postgres accepts in a tsvector.
   *
   * @param text the text
   * @return the text, at most {@link FeedTextFetcher#MAX_TEXT_LENGTH} long
   */
  private static String truncate(String text) {
    return text.length() > FeedTextFetcher.MAX_TEXT_LENGTH
        ? text.substring(0, FeedTextFetcher.MAX_TEXT_LENGTH)
        : text;
  }

  /**
   * Finds a podcast in the iTunes directory, to know its genre.
   *
   * @param podcast the podcast
   * @return the iTunes entry with the same feed URL, or else with the same name
   */
  private Optional<SearchResult> findItunesEntry(Podcast podcast) {
    if (podcast.getName() == null || podcast.getName().isBlank()) {
      return Optional.empty();
    }
    List<SearchResult> results =
        safely(
            () -> itunes.searchWithoutColors(podcast.getName(), COUNTRY, 10),
            "iTunes search of podcast " + podcast.getName());
    String feedUrl = normalizeUrl(podcast.getUrl());
    return results.stream()
        .filter(r -> normalizeUrl(r.getFeedUrl()).equals(feedUrl))
        .findFirst()
        .or(
            () ->
                results.stream()
                    .filter(r -> podcast.getName().equalsIgnoreCase(r.getCollectionName()))
                    .findFirst());
  }

  /**
   * Gathers the podcasts that may be recommended: iTunes search results for the episode's top
   * keywords, and the top podcasts of the podcast's genre. Sources are interleaved so that each is
   * represented when the candidates are capped to {@link #MAX_CANDIDATES}.
   *
   * <p>When the podcast's iTunes genres are known, candidates must share one of them: a single
   * keyword search mostly matches podcast names, so "leadership" in an episode title about Nvidia
   * finds business coaching shows, and a host named Chacos finds Gran Chaco history podcasts.
   *
   * @param podcast the episode's podcast, excluded from the candidates
   * @param keywords the episode's keywords, most distinctive first
   * @param itunesEntry the podcast's iTunes entry, for its genre
   * @return the candidates, without duplicates or subscribed podcasts
   */
  private Collection<Candidate> gatherCandidates(
      Podcast podcast, List<Keyword> keywords, Optional<SearchResult> itunesEntry) {
    List<String> terms = new ArrayList<>();
    if (keywords.size() >= 2) {
      // both top words together is the most precise search, when it matches anything
      terms.add(keywords.get(0).getToken() + " " + keywords.get(1).getToken());
    }
    keywords.stream().limit(SEARCHED_KEYWORDS).map(Keyword::getToken).forEach(terms::add);

    List<CompletableFuture<List<SearchResult>>> sources = new ArrayList<>();
    List<String> sourceNames = new ArrayList<>();
    for (String term : terms) {
      sourceNames.add(term);
      sources.add(
          CompletableFuture.supplyAsync(
              () ->
                  safely(
                      () -> itunes.searchWithoutColors(term, COUNTRY, RESULTS_PER_SEARCH),
                      "iTunes search of " + term),
              EXECUTOR));
    }
    itunesEntry
        .flatMap(RecommendationService::genreId)
        .ifPresent(
            genreId -> {
              sourceNames.add(CHART_SOURCE);
              sources.add(
                  CompletableFuture.supplyAsync(
                      () ->
                          safely(
                              () ->
                                  itunes.lookupByIds(
                                      itunes.topPodcastIds(genreId, COUNTRY, CHART_SIZE)),
                              "iTunes top podcasts of genre " + genreId),
                      EXECUTOR));
            });

    Set<String> excluded = new HashSet<>();
    excluded.add(normalizeUrl(podcast.getUrl()));
    podcastRepository.findAllUrls().stream()
        .map(RecommendationService::normalizeUrl)
        .forEach(excluded::add);

    Set<String> genres = itunesEntry.map(RecommendationService::specificGenres).orElse(Set.of());

    List<Iterator<SearchResult>> iterators =
        sources.stream().map(f -> f.join().iterator()).toList();
    Map<String, Candidate> candidates = new LinkedHashMap<>();
    boolean remaining = true;
    while (remaining && candidates.size() < MAX_CANDIDATES) {
      remaining = false;
      for (int i = 0; i < iterators.size(); i++) {
        Iterator<SearchResult> it = iterators.get(i);
        if (it.hasNext() && candidates.size() < MAX_CANDIDATES) {
          remaining = true;
          SearchResult candidate = it.next();
          String url = normalizeUrl(candidate.getFeedUrl());
          boolean sharesGenre =
              genres.isEmpty() || specificGenres(candidate).stream().anyMatch(genres::contains);
          if (!url.isEmpty() && !excluded.contains(url) && sharesGenre) {
            candidates.putIfAbsent(url, new Candidate(candidate, sourceNames.get(i)));
          }
        }
      }
    }
    return candidates.values();
  }

  /**
   * Scores a candidate: the cosine similarity between the episode's keyword weights and the
   * (log-scaled) word counts of the candidate's feed text.
   *
   * @param candidate the candidate
   * @param sourceVector the episode's keyword weights, by lexeme
   * @param primaryGenre the primary genre of the episode's podcast, may be null
   * @return the scored candidate, or empty when its feed couldn't be read
   */
  private Optional<Scored> score(
      Candidate candidate, Map<String, Double> sourceVector, String primaryGenre) {
    SearchResult result = candidate.result();
    Optional<String> feedText = feedTextFetcher.fetchText(result.getFeedUrl(), FEED_ITEMS);
    if (feedText.isEmpty()) {
      return Optional.empty();
    }
    String text =
        truncate(
            Objects.toString(result.getCollectionName(), "") + "\n" + withoutAds(feedText.get()));

    List<LexemeCount> counts;
    try {
      counts = recommendationsRepository.countLexemes(text);
    } catch (RuntimeException e) {
      log.debug("Could not analyze feed {}: {}", result.getFeedUrl(), e.getMessage());
      return Optional.empty();
    }

    double score = cosine(sourceVector, counts);
    if (primaryGenre != null && primaryGenre.equals(result.getPrimaryGenreName())) {
      score *= SAME_GENRE_BOOST;
    }
    return Optional.of(new Scored(candidate, score));
  }

  /**
   * Cosine similarity between keyword weights and log-scaled word counts.
   *
   * @param sourceVector keyword weights by lexeme
   * @param counts word counts of the other text
   * @return the similarity, between 0 and 1
   */
  static double cosine(Map<String, Double> sourceVector, List<LexemeCount> counts) {
    double dot = 0;
    double countNorm = 0;
    for (LexemeCount count : counts) {
      double value = 1 + Math.log(Math.max(count.getCount(), 1));
      countNorm += value * value;
      Double weight = sourceVector.get(count.getLexeme());
      if (weight != null) {
        dot += weight * value;
      }
    }
    double sourceNorm = sourceVector.values().stream().mapToDouble(w -> w * w).sum();
    if (dot == 0 || countNorm == 0 || sourceNorm == 0) {
      return 0;
    }
    return dot / (Math.sqrt(sourceNorm) * Math.sqrt(countNorm));
  }

  /**
   * The most specific iTunes genre of a podcast.
   *
   * @param entry the podcast's iTunes entry
   * @return its first genre id that isn't the generic "Podcasts" genre
   */
  private static Optional<String> genreId(SearchResult entry) {
    if (entry.getGenreIds() == null) {
      return Optional.empty();
    }
    return entry.getGenreIds().stream().filter(id -> !PODCASTS_GENRE_ID.equals(id)).findFirst();
  }

  /**
   * The genres of a podcast, without the generic "Podcasts" genre every podcast has.
   *
   * @param entry the podcast's iTunes entry
   * @return its genre names
   */
  static Set<String> specificGenres(SearchResult entry) {
    if (entry.getGenres() == null) {
      return Set.of();
    }
    return entry.getGenres().stream()
        .filter(g -> !PODCASTS_GENRE_NAME.equals(g))
        .collect(Collectors.toSet());
  }

  /**
   * Normalizes a feed URL so the same feed is recognized across http/https and trailing slashes.
   *
   * @param url the feed URL, may be null
   * @return the normalized URL, empty for null
   */
  static String normalizeUrl(String url) {
    if (url == null) {
      return "";
    }
    String normalized = url.strip().toLowerCase(Locale.ROOT).replaceFirst("^https?://", "");
    while (normalized.endsWith("/")) {
      normalized = normalized.substring(0, normalized.length() - 1);
    }
    return normalized;
  }

  /**
   * Runs an iTunes call, logging and ignoring failures so that one failing source doesn't prevent
   * recommendations from the others.
   *
   * @param call the call
   * @param description what the call does, for the logs
   * @return the call's results, or an empty list if it failed
   */
  private static List<SearchResult> safely(Supplier<List<SearchResult>> call, String description) {
    try {
      return call.get();
    } catch (RuntimeException e) {
      log.warn("{} failed: {}", description, e.getMessage());
      return List.of();
    }
  }

  /**
   * Serializes recommendations for the cache.
   *
   * @param results the recommendations
   * @return the JSON array
   */
  private String toJson(List<SearchResult> results) {
    try {
      return objectMapper.writeValueAsString(results);
    } catch (JsonProcessingException e) {
      throw new IllegalStateException("Could not serialize recommendations", e);
    }
  }

  /**
   * Deserializes cached recommendations.
   *
   * @param json the JSON array
   * @return the recommendations
   */
  private List<SearchResult> fromJson(String json) {
    try {
      return objectMapper.readValue(json, new TypeReference<List<SearchResult>>() {});
    } catch (JsonProcessingException e) {
      log.warn("Invalid cached recommendations, ignoring them: {}", e.getMessage());
      return List.of();
    }
  }

  /**
   * A podcast that may be recommended.
   *
   * @param result the podcast
   * @param source the keyword search that found it, or {@link #CHART_SOURCE} for the genre chart
   */
  record Candidate(SearchResult result, String source) {}

  /**
   * A candidate and its score.
   *
   * @param candidate the candidate
   * @param score its similarity to the episode
   */
  record Scored(Candidate candidate, double score) {}
}
