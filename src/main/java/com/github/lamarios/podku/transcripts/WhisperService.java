/* (C)2026 */
package com.github.lamarios.podku.transcripts;

import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.episodes.EpisodeUtils;
import com.github.lamarios.podku.episodes.VttParser;
import com.github.lamarios.podku.utils.BackgroundTasks;
import com.github.lamarios.podku.utils.TransactionHelper;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.http.HttpClient;
import java.nio.file.Path;
import java.util.List;
import kong.unirest.core.HttpResponse;
import kong.unirest.core.Unirest;
import kong.unirest.core.UnirestInstance;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;

/**
 * Class to generate transcript for podcast episodes talks to whisper server image:
 * https://hub.docker.com/r/hwdsl2/whisper-server/
 */
@Service
public class WhisperService {
  private final PlatformTransactionManager transactionManager;
  private final EpisodeTranscriptRepository episodeTranscriptRepository;
  private final TranscriptService transcriptService;
  private static final String AI_TRANSCRIPT_LANGUAGE = "a.i";
  private final Logger log = LogManager.getLogger();
  private final Path episodeCacheFolder;
  private final String whisperUrl, whisperModel, whisperApiKey;
  private final EpisodeRepository episodeRepository;
  private final int episodeProcessCount;

  public WhisperService(
      PlatformTransactionManager transactionManager,
      EpisodeTranscriptRepository episodeTranscriptRepository,
      TranscriptService transcriptService,
      @Value("${whisper.url}") String whisperUrl,
      @Value("${whisper.model}") String whisperModel,
      @Value("${whisper.apiKey}") String whisperApiKey,
      @Value("${whisper.episodeProcessCount}") String episodeProcessCount,
      @Value("${podku.episodes.cache-dir:./episode-cache}") String episodeCacheFolder,
      EpisodeRepository episodeRepository) {
    this.transactionManager = transactionManager;
    this.episodeTranscriptRepository = episodeTranscriptRepository;
    this.transcriptService = transcriptService;
    Path p = Path.of(episodeCacheFolder);
    if (!p.toFile().exists()) {
      p.toFile().mkdirs();
    }

    this.episodeCacheFolder = p;
    this.whisperApiKey = whisperApiKey;
    this.whisperModel = whisperModel;
    this.whisperUrl = whisperUrl;
    this.episodeRepository = episodeRepository;
    this.episodeProcessCount = Integer.parseInt(episodeProcessCount);
  }

  public boolean isWhisperEnabled() {
    return whisperUrl != null && !whisperUrl.isBlank();
  }

  public void processEpisode(Episode e) {
    if (isWhisperEnabled()) {
      BackgroundTasks.submitBackgroundTask(() -> processEpisodeInner(e));
    } else {
      log.info("Whisper is not enable for transcript processing");
    }
  }

  @Scheduled(cron = "0 0 4 * * *")
  public void processEpisodeCron() {
    if (episodeProcessCount > 0) {
      var episodes =
          episodeRepository.getEpisodeByPubDateMillisBefore(
              System.currentTimeMillis(),
              Sort.by(Sort.Direction.DESC, "pubDateMillis"),
              Limit.of(episodeProcessCount));
      episodes.forEach(this::processEpisode);
    }
  }

  private void processEpisodeInner(Episode e) {
    TransactionHelper.doInNewTransaction(
        transactionManager,
        false,
        () -> {
          var start = System.currentTimeMillis();

          log.info("Processing episode {} for transcript generation", e.getTitle());
          List<String> languages = transcriptService.getLanguages(e.getId().toString());
          if (!languages.isEmpty()) {
            log.info("Episode already has transcript");
            return;
          }
          // if none we download the audio file (if not cached)
          try {
            Path episode = EpisodeUtils.downloadEpisode(e, episodeCacheFolder);
            // we send it to whisper
            try (UnirestInstance client = Unirest.spawnInstance();
                InputStream fis = new FileInputStream(episode.toFile())) {
              log.info("Sending transcription to {}", whisperUrl);
              client
                  .config()
                  .connectTimeout(Integer.MAX_VALUE)
                  .requestTimeout(Integer.MAX_VALUE)
                  .version(HttpClient.Version.HTTP_1_1);

              var request =
                  client
                      .post(whisperUrl + "/v1/audio/transcriptions")
                      .header("Authorization", "Bearer " + whisperApiKey)
                      .field("file", fis, episode.getFileName().toString())
                      .field("model", whisperModel)
                      .field("response_format", "vtt");

              if (whisperApiKey != null) {
                request = request.header("Authorization", "Bearer " + whisperApiKey);
              }
              HttpResponse<String> response = request.asString();

              if (response.isSuccess()) {
                var transcripts =
                    new VttParser().parse(response.getBody(), e, AI_TRANSCRIPT_LANGUAGE);
                episodeTranscriptRepository.saveAll(transcripts);
                log.info("Saved {} lines of transcript", transcripts.size());
              }
            }
          } catch (IOException ex) {
            log.error("Failed to process episode", ex);
            throw new RuntimeException(ex);
          } finally {
            log.info("Transcript process time: ~{}s", (System.currentTimeMillis() - start) / 1000);
          }
        });
  }
}
