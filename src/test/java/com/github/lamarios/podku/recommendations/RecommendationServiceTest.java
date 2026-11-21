package com.github.lamarios.podku.recommendations;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.mock.MockFeedController;
import com.github.lamarios.podku.podcasts.PodcastService;
import com.github.lamarios.podku.search.ItunesPodcastSearch;
import com.github.lamarios.podku.search.SearchResult;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.web.server.ResponseStatusException;

public class RecommendationServiceTest extends TestContainerTest {

  @Autowired private RecommendationController recommendationController;
  @Autowired private PodcastService podcastService;
  @Autowired private EpisodeRepository episodeRepository;
  @Autowired private EpisodeRecommendationsRepository recommendationsRepository;

  @MockitoBean private ItunesPodcastSearch itunesPodcastSearch;

  private static String feed(String title, String description, String... items) {
    StringBuilder sb = new StringBuilder();
    for (int i = 0; i < items.length; i++) {
      sb.append(
          """
          <item>
            <title>%s</title>
            <description>%s</description>
            <guid>%s-%d</guid>
            <pubDate>Mon, 0%d Jan 2024 12:00:00 GMT</pubDate>
            <enclosure url="http://localhost/%d.mp3" length="1" type="audio/mpeg"/>
          </item>
          """
              .formatted(items[i], items[i], title.replaceAll("\\W", ""), i, i + 1, i));
    }
    return """
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0">
          <channel>
            <title>%s</title>
            <description>%s</description>
            %s
          </channel>
        </rss>
        """
        .formatted(title, description, sb);
  }

  private SearchResult result(String name, String feedName) {
    SearchResult result = new SearchResult();
    result.setCollectionName(name);
    result.setFeedUrl(getBaseUrl() + "/mock/dynamic/" + feedName);
    return result;
  }

  private Episode subscribeToSource() {
    MockFeedController.serve(
        "source",
        feed(
            "Cloud Native Weekly",
            "A show about running software in the cloud",
            "Kubernetes operators and container orchestration explained",
            "Scaling kubernetes clusters with container autoscaling"));
    podcastService.subscribe(result("Cloud Native Weekly", "source"));
    return episodeRepository.findAll().getFirst();
  }

  @Test
  public void testRanksCandidatesBySimilarity() {
    Episode episode = subscribeToSource();

    MockFeedController.serve(
        "k8s",
        feed(
            "Containers Today",
            "Kubernetes, containers and orchestration news",
            "Kubernetes 2.0 released",
            "Container security on kubernetes"));
    MockFeedController.serve(
        "devops",
        feed(
            "Ops Life",
            "Operations and on call stories",
            "Our kubernetes outage",
            "Pager duty tips"));
    MockFeedController.serve(
        "cooking",
        feed("Kitchen Talk", "Recipes and cooking tips", "Sourdough bread", "Pasta sauce"));

    when(itunesPodcastSearch.searchWithoutColors(anyString(), anyString(), anyInt()))
        .thenAnswer(
            _ ->
                new ArrayList<>(
                    List.of(
                        result("Kitchen Talk", "cooking"),
                        result("Ops Life", "devops"),
                        result("Containers Today", "k8s"),
                        result("Dead Feed", "missing"),
                        // the podcast itself is never recommended
                        result("Cloud Native Weekly", "source"))));
    when(itunesPodcastSearch.withColors(any())).thenAnswer(inv -> inv.getArgument(0));

    List<SearchResult> recommendations =
        recommendationController.getEpisodeRecommendations(episode.getId(), 6);

    assertEquals(
        List.of("Containers Today", "Ops Life"),
        recommendations.stream().map(SearchResult::getCollectionName).toList());
  }

  @Test
  public void testCachesAndFiltersSubscriptions() {
    Episode episode = subscribeToSource();
    MockFeedController.serve(
        "k8s", feed("Containers Today", "Kubernetes news", "Kubernetes container orchestration"));

    when(itunesPodcastSearch.searchWithoutColors(anyString(), anyString(), anyInt()))
        .thenAnswer(_ -> new ArrayList<>(List.of(result("Containers Today", "k8s"))));
    when(itunesPodcastSearch.withColors(any())).thenAnswer(inv -> inv.getArgument(0));

    assertEquals(1, recommendationController.getEpisodeRecommendations(episode.getId(), 6).size());
    assertTrue(recommendationsRepository.existsById(episode.getId()));

    clearInvocations(itunesPodcastSearch);
    assertEquals(1, recommendationController.getEpisodeRecommendations(episode.getId(), 6).size());
    verifyNoInteractions(itunesPodcastSearch);

    // subscribing to a recommendation removes it from the cached recommendations
    podcastService.subscribe(result("Containers Today", "k8s"));
    assertTrue(recommendationController.getEpisodeRecommendations(episode.getId(), 6).isEmpty());
  }

  @Test
  public void testKeepsOnlyCandidatesSharingAGenre() {
    Episode episode = subscribeToSource();
    MockFeedController.serve(
        "k8s", feed("Containers Today", "Kubernetes news", "Kubernetes container orchestration"));
    MockFeedController.serve(
        "coaching",
        feed("Kubernetes Leadership", "Business coaching", "Leading kubernetes container teams"));

    SearchResult source = result("Cloud Native Weekly", "source");
    source.setGenres(List.of("Technology", "Podcasts"));
    SearchResult tech = result("Containers Today", "k8s");
    tech.setGenres(List.of("Technology", "Podcasts"));
    SearchResult business = result("Kubernetes Leadership", "coaching");
    business.setGenres(List.of("Business", "Podcasts"));

    when(itunesPodcastSearch.searchWithoutColors(anyString(), anyString(), anyInt()))
        .thenAnswer(
            inv ->
                inv.getArgument(0).equals("Cloud Native Weekly")
                    ? new ArrayList<>(List.of(source))
                    : new ArrayList<>(List.of(business, tech)));
    when(itunesPodcastSearch.withColors(any())).thenAnswer(inv -> inv.getArgument(0));

    assertEquals(
        List.of("Containers Today"),
        recommendationController.getEpisodeRecommendations(episode.getId(), 6).stream()
            .map(SearchResult::getCollectionName)
            .toList());
  }

  @Test
  public void testUnknownEpisode() {
    ResponseStatusException e =
        assertThrows(
            ResponseStatusException.class,
            () -> recommendationController.getEpisodeRecommendations(UUID.randomUUID(), 6));
    assertEquals(HttpStatus.NOT_FOUND, e.getStatusCode());
  }
}
