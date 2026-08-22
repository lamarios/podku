/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import com.github.lamarios.podku.transcripts.EpisodeTranscriptRepository;
import com.github.lamarios.podku.utils.TransactionHelper;
import com.github.lamarios.podku.websockets.PlaybackProgress;
import com.github.lamarios.podku.websockets.WebSocketSessionManager;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;
import kong.unirest.core.Unirest;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

@Service
public class EpisodeService {
  private final Logger log = LogManager.getLogger();
  public static final String TEXT_VTT = "text/vtt";
  public static final String APPLICATION_X_SUBRIP = "application/x-subrip";
  private final ChapterRepository chapterRepository;
  private final EpisodeTranscriptRepository episodeTranscriptRepository;
  private final EpisodeRepository episodeRepository;
  private final ExecutorService exec = Executors.newSingleThreadExecutor();
  private final PlatformTransactionManager transactionManager;
  private final WebSocketSessionManager webSocketSessionManager;

  @Autowired
  public EpisodeService(
      ChapterRepository chapterRepository,
      EpisodeTranscriptRepository episodeTranscriptRepository,
      EpisodeRepository episodeRepository,
      PlatformTransactionManager transactionManager,
      WebSocketSessionManager webSocketSessionManager) {
    this.chapterRepository = chapterRepository;
    this.episodeTranscriptRepository = episodeTranscriptRepository;
    this.episodeRepository = episodeRepository;
    this.transactionManager = transactionManager;
    this.webSocketSessionManager = webSocketSessionManager;
  }

  /**
   * Process a podcast in a separated queue
   *
   * @param podcast the podcast to process
   */
  public CompletableFuture<Podcast> processPodcast(Podcast podcast) {
    CompletableFuture<Podcast> future = new CompletableFuture<>();
    exec.submit(
        () -> {
          try {
            for (Episode episode : podcast.getEpisodes()) {
              TransactionHelper.doInNewTransaction(
                  transactionManager,
                  false,
                  () -> {
                    var e = episodeRepository.findById(episode.getId());
                    e.ifPresent(this::processEpisode);
                  });
            }
          } finally {
            future.complete(podcast);
          }
        });

    return future;
  }

  @Scheduled(cron = "@daily")
  public void processEpisodes() {
    exec.submit(
        () -> {
          log.info("Starting scheduled episode processing");
          episodeRepository
              .streamAllByProcessed(false)
              .forEach(
                  episode -> {
                    TransactionHelper.doInNewTransaction(
                        transactionManager,
                        false,
                        () -> {
                          var e = episodeRepository.findById(episode.getId());
                          e.ifPresent(this::processEpisode);
                        });
                  });
        });
  }

  /**
   * Processes a single episode to get transcripts and chapters
   *
   * @param episode the episode to process
   */
  private void processEpisode(Episode episode) {
    log.info("Processing episode: {}", episode.getTitle());

    if (episode.getFiles() == null || episode.getFiles().isEmpty()) {
      episode.setProcessed(true);
      episodeRepository.save(episode);
      log.info("Episode {} has nothing to process", episode.getTitle());
      return;
    }

    if (episode.isProcessed()) {
      log.info("Episode {} has already been processed", episode.getTitle());
      return;
    }

    for (var f :
        episode.getFiles().stream().filter(f -> f.getType() == EpisodeFileType.chapters).toList()) {
      var chapters = getChapters(f);
      for (Chapter chapter : chapters) {
        chapter.setEpisode(episode);
      }
      if (episode.getChapters() == null) {
        episode.setChapters(chapters);
      } else {
        episode.getChapters().clear();
        ;
        episode.getChapters().addAll(chapters);
      }
    }
    // saving transcript
    List<EpisodeFile> transcriptFiles =
        episode.getFiles().stream()
            .filter(f -> f.getType() == EpisodeFileType.transcript)
            .sorted(
                (a, b) -> {
                  if (a.getMime().equalsIgnoreCase(b.getMime())) {
                    return 0;
                  }
                  if (a.getMime().equalsIgnoreCase(TEXT_VTT)) {
                    return -1;
                  }
                  if (b.getMime().equalsIgnoreCase(TEXT_VTT)) {
                    return 1;
                  }
                  return 0;
                })
            .toList();

    for (EpisodeFile f : transcriptFiles) {
      var existing =
          episodeTranscriptRepository.findFirstByEpisodeEqualsAndLanguage(episode, f.getLanguage());

      if (existing != null) {
        continue;
      }

      String response = Unirest.get(f.getUrl()).asString().getBody();

      List<EpisodeTranscript> transcript = new ArrayList<>();
      if (f.getMime().equalsIgnoreCase(TEXT_VTT)) {
        transcript.addAll(new VttParser().parse(response, episode, f.getLanguage()));
      } else if (f.getMime().equalsIgnoreCase(APPLICATION_X_SUBRIP)) {
        transcript.addAll(new SrtParser().parse(response, episode, f.getLanguage()));
      }
      //            episodeTranscriptRepository.saveAll(transcript);
      if (episode.getTranscripts() == null) {
        episode.setTranscripts(transcript);
      } else {
        episode.getTranscripts().clear();
        episode.getTranscripts().addAll(transcript);
      }
      log.info(
          "inserted {} transcript lines for episode {}", transcript.size(), episode.getTitle());
    }

    episode.setProcessed(true);

    episodeRepository.save(episode);
  }

  /**
   * Gets the chapters of an episode
   *
   * @param f the episode file
   * @return the list of chapters
   */
  private List<Chapter> getChapters(EpisodeFile f) {
    var request = Unirest.get(f.getUrl());
    var response = request.asObject(Chapters.class);

    return response.getBody().getChapters();
  }

  /**
   * Gets episodes
   *
   * @param before timestamp from which to get episodes from
   * @param pageSize how many to retrieve
   * @return list of episodes
   */
  @Transactional(readOnly = true)
  public List<Episode> getEpisodes(Long before, int pageSize) {
    return episodeRepository.getEpisodeByPubDateMillisBefore(
        before, Sort.by(Sort.Direction.DESC, "pubDateMillis"), Limit.of(pageSize));
  }

  /**
   * Gets a single episode
   *
   * @param id the id of the episode
   * @return the episode or null
   */
  @Transactional(readOnly = true)
  public Episode getEpisode(String id) {
    return episodeRepository.findById(UUID.fromString(id)).orElse(null);
  }

  /**
   * Set user progress on episode and transmit it to other connect clients if any
   *
   * @param progress
   */
  @Transactional
  public void setProgress(PlaybackProgress progress) {
    var episode = getEpisode(progress.episodeId().toString());
    if (episode != null) {
      episode.setProgress(progress.progress());
      episodeRepository.save(episode);
      webSocketSessionManager.sendToUsers(progress);
    }
  }

  @Transactional(readOnly = true)
  public List<EpisodeSearchResult> searchPodcasts(String query, int limit) {
    String tsQuery =
        Arrays.stream(query.trim().split("\\s+"))
            .filter(s -> !s.isBlank())
            .map(s -> s.replaceAll("[^a-zA-Z0-9]", "") + ":*")
            .collect(Collectors.joining(" & "));

    if (tsQuery.isBlank()) {
      return List.of();
    }
    List<Episode> searchResult = episodeRepository.search(tsQuery, limit);

    List<UUID> episodeIds = searchResult.stream().map(Episode::getId).toList();
    System.out.println(episodeIds.stream().map(UUID::toString).collect(Collectors.joining("','")));

    if (!episodeIds.isEmpty()) {
      var mapped =
          episodeTranscriptRepository.search(tsQuery, episodeIds.toArray(new UUID[0])).stream()
              .map(
                  t -> {
                    EpisodeTranscript transcript = new EpisodeTranscript();
                    transcript.setId((UUID) t.get("id"));
                    if (t.get("content") != null) {
                      transcript.setContent((String) t.get("content"));
                    }
                    if (t.get("start_time") != null) {
                      transcript.setStartTime((String) t.get("start_time"));
                    }

                    if (t.get("end_time") != null) {
                      transcript.setEndTime((String) t.get("end_time"));
                    }

                    if (t.get("speaker") != null) transcript.setSpeaker((String) t.get("speaker"));
                    if (t.get("content") != null) transcript.setContent((String) t.get("content"));
                    if (t.get("language") != null)
                      transcript.setLanguage((String) t.get("language"));
                    if (t.get("episode_id") != null) {
                      Episode episode = new Episode();
                      episode.setId((UUID) t.get("episode_id"));
                      transcript.setEpisode(episode);
                    }
                    if (t.get("highlighted_content") != null)
                      transcript.setHighlightedContent((String) t.get("highlighted_content"));

                    return transcript;
                  })
              .collect(Collectors.groupingBy(t -> t.getEpisode().getId().toString()));
      /*
                          .stream()
                          .collect(Collectors.groupingBy(episodeTranscript ->
                                  episodeTranscript.
                                  episodeTranscript.getEpisode()
                                  .getId().toString()));
      */
      return searchResult.stream()
          .map(
              episode ->
                  new EpisodeSearchResult(
                      episode,
                      mapped.getOrDefault(episode.getId().toString(), Collections.emptyList())))
          .toList();
      //            return searchResult.stream().map(episode -> new EpisodeSearchResult(episode,
      // Collections.emptyList())).toList();
    } else {
      return Collections.emptyList();
    }
  }

  @Transactional
  public boolean updateProgresses(Map<String, OfflineProgress> progresses) {
    progresses.forEach(
        (episodeId, offlineProgress) -> {
          episodeRepository
              .findById(UUID.fromString(episodeId))
              .filter(
                  e ->
                      e.getTimeUpdated() == null
                          || e.getTimeUpdated() < offlineProgress.getTimeOfProgress())
              .ifPresent(
                  e -> {
                    e.setProgress(offlineProgress.getProgress());
                    episodeRepository.save(e);
                  });
        });
    return true;
  }
}
