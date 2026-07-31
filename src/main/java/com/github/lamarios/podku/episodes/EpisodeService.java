package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import com.github.lamarios.podku.transcripts.EpisodeTranscriptRepository;
import com.github.lamarios.podku.utils.TransactionHelper;
import com.github.lamarios.podku.websockets.PlaybackProgress;
import com.github.lamarios.podku.websockets.WebSocketSessionManager;
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

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

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

    @Autowired
    public EpisodeService(ChapterRepository chapterRepository, EpisodeTranscriptRepository episodeTranscriptRepository, EpisodeRepository episodeRepository, PlatformTransactionManager transactionManager) {
        this.chapterRepository = chapterRepository;
        this.episodeTranscriptRepository = episodeTranscriptRepository;
        this.episodeRepository = episodeRepository;
        this.transactionManager = transactionManager;
    }

    /**
     * Process a podcast in a separated queue
     *
     * @param podcast the podcast to process
     */
    public void processPodcast(Podcast podcast) {
        exec.submit(() -> {
            for (Episode episode : podcast.getEpisodes()) {
                TransactionHelper.doInNewTransaction(transactionManager, false, () -> {
                    var e = episodeRepository.findById(episode.getId());
                    e.ifPresent(this::processEpisode);
                });
            }
        });
    }

    @Scheduled(cron = "@daily")
    public void processEpisodes() {
        TransactionHelper.doInNewTransaction(transactionManager, true, () -> {
            var toProcess = episodeRepository.findAllByProcessed(false);
            exec.submit(() -> {
                log.info("Starting scheduled episode processing, {} episodes to process", toProcess.size());
                for (Episode episode : toProcess) {
                    TransactionHelper.doInNewTransaction(transactionManager, false, () -> {
                        var e = episodeRepository.findById(episode.getId());
                        e.ifPresent(this::processEpisode);
                    });
                }
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

        if(episode.isProcessed()){
            log.info("Episode {} has already been processed", episode.getTitle());
            return;
        }



        for (var f : episode.getFiles().stream().filter(f -> f.getType() == EpisodeFileType.chapters).toList()) {
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
        List<EpisodeFile> transcriptFiles = episode.getFiles().stream().filter(f -> f.getType() == EpisodeFileType.transcript)
                .sorted((a, b) -> {
                            if (a.getMime().equalsIgnoreCase(b.getMime())) return 0;
                            if (a.getMime().equalsIgnoreCase(TEXT_VTT)) return -1;
                            if (b.getMime().equalsIgnoreCase(TEXT_VTT)) return 1;
                            return 0;
                        }
                )
                .toList();

        for (EpisodeFile f : transcriptFiles) {

            var existing = episodeTranscriptRepository.findFirstByEpisodeEqualsAndLanguage(episode, f.getLanguage());

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
            log.info("inserted {} transcript lines for episode {}", transcript.size(), episode.getTitle());

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
     * @param before   timestamp from which to get episodes from
     * @param pageSize how many to retrieve
     * @return list of episodes
     */
    @Transactional(readOnly = true)
    public List<Episode> getEpisodes(Long before, int pageSize) {
        return episodeRepository.getEpisodeByPubDateMillisBefore(before, Sort.by(Sort.Direction.DESC, "pubDateMillis"), Limit.of(pageSize));
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
            WebSocketSessionManager.sendToUsers(progress);
        }
    }
}
