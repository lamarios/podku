package com.github.lamarios.podku.podcasts;

import be.ceau.opml.OpmlParseException;
import be.ceau.opml.OpmlParser;
import be.ceau.opml.OpmlWriteException;
import be.ceau.opml.OpmlWriter;
import be.ceau.opml.entity.Body;
import be.ceau.opml.entity.Head;
import be.ceau.opml.entity.Opml;
import be.ceau.opml.entity.Outline;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.episodes.EpisodeService;
import com.github.lamarios.podku.episodes.EpisodeUtils;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.transcripts.WhisperService;
import com.github.lamarios.podku.utils.TransactionHelper;
import com.google.common.hash.Hashing;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Service
public class PodcastService {
    private final Logger log = LogManager.getLogger();
    private final PodcastRepository podcastRepository;
    private final EpisodeService episodeService;
    private final PlatformTransactionManager platformTransactionManager;
    private final EpisodeRepository episodeRepository;
    private final int episodeCacheCount;
    private final Path episodeCacheFolder;
    private final PodcastParser podcastParser;
    private final WhisperService whisperService;


    @Autowired
    public PodcastService(PodcastRepository podcastRepository, EpisodeService episodeService, @Qualifier("transactionManager") PlatformTransactionManager platformTransactionManager, EpisodeRepository episodeRepository, @Value("${podku.episodes.cache-dir:./episode-cache}") String episodeCacheFolder, @Value("${podku.episodes.cache-count:0}") String episodeCacheCount, PodcastParser podcastParser, WhisperService whisperService) {
        this.podcastRepository = podcastRepository;
        this.episodeService = episodeService;
        this.platformTransactionManager = platformTransactionManager;
        this.episodeRepository = episodeRepository;
        this.episodeCacheCount = Integer.parseInt(episodeCacheCount);

        Path p = Path.of(episodeCacheFolder);
        if (!p.toFile().exists()) {
            p.toFile().mkdirs();
        }

        this.episodeCacheFolder = p;
        this.podcastParser = podcastParser;
        this.whisperService = whisperService;
    }


    @Transactional(readOnly = true)
    public List<Podcast> getPodcasts() {
        return podcastRepository.findAll(Sort.by(Sort.Direction.ASC, "name"));
    }


    @Transactional
    public Podcast subscribe(SearchResult result) {
        if (result.getFeedUrl() != null) {
            Optional<Podcast> alreadySubscribed = podcastRepository.findFirstByUrl(result.getFeedUrl());
            if (alreadySubscribed.isPresent()) {
                return null;
            } else {
                Podcast podcast = new Podcast();
                podcast.setUrl(result.getFeedUrl());
                String name = result.getCollectionName();

                podcast.setName(name);
                podcast.setArtworkUrl(result.getArtworkUrl());

                podcast = podcastParser.parseUrl(podcast);

                podcastRepository.save(podcast);
                episodeService.processPodcast(podcast).thenAccept(_ -> whisperService.processEpisodeCron());
                return podcast;
            }
        } else {
            return null;
        }

    }

    @Transactional(readOnly = true)
    public Podcast getPodcast(String id) {
        return podcastRepository.findById(UUID.fromString(id)).orElse(null);
    }

    @Transactional
    public void unsubscribe(String id) {
        podcastRepository.deletePodcastById(UUID.fromString(id));
    }


    @Scheduled(cron = "@hourly")
    public void refreshPodcasts() {
        List<Podcast> podcasts = TransactionHelper.doInNewTransaction(platformTransactionManager, false, () -> {
            List<Podcast> result = new ArrayList<>();
            var toProcess = podcastRepository.findAll();
            for (var podcast : toProcess) {
                TransactionHelper.doInNewTransaction(platformTransactionManager, false, () -> {
                    Podcast parsed = null;
                    log.info("Refreshing podcast {}", podcast.getName());

                    parsed = podcastParser.parseUrl(podcast);
                    podcastRepository.save(parsed);
                    result.add(parsed);
                });
            }

            return result;
        });

        log.info("Episode refresh done");
        try {
            downloadEpisodes();
        } catch (Exception e) {
            log.error("Error while downloading episodes", e);
        }
        // we wait for the episode process to finish
        List<CompletableFuture<Podcast>> futures = podcasts.stream().map(episodeService::processPodcast).toList();
        CompletableFuture<Void> combined = CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));

        combined.join();
        // then we process whisper
        whisperService.processEpisodeCron();
    }

    @Transactional(readOnly = true)
    public String exportPodcasts() throws OpmlWriteException {
        List<Podcast> feeds = podcastRepository.findAll();

        Head head = new Head("Podku", LocalDateTime.now().toString(), null, null, null, null, null, null, null, null, null, null, null);

        List<Outline> outlines = feeds.stream().map(feed -> new Outline(Map.of("type", "rss", "xmlUrl", feed.getUrl(), "title", feed.getName()), Collections.emptyList())).toList();

        Body body = new Body(outlines);

        Opml opml = new Opml("2.0", head, body);

        OpmlWriter writer = new OpmlWriter();

        return writer.write(opml);
    }

    @Transactional
    public List<Podcast> importPodcasts(MultipartFile file) throws IOException, OpmlParseException, SQLException {
        log.info("Importing feed");
        Path tempDirectory = Files.createTempDirectory("newsku-opml-import");
        Path p = tempDirectory.resolve("import.opml");
        file.transferTo(p);
        List<Podcast> newPodcasts = new ArrayList<>();

        try (var is = new FileInputStream(p.toFile())) {
            var parser = new OpmlParser().parse(is);
            for (Outline outline : parser.getBody().getOutlines()) {
                newPodcasts.addAll(importPodcast(outline));
            }


            podcastRepository.saveAll(newPodcasts);

            return newPodcasts;
        } catch (SQLException | OpmlParseException e) {
            log.error("Failed to parse opml file", e);
            throw e;
        } finally {
            Files.deleteIfExists(p);
            Files.deleteIfExists(tempDirectory);
        }
    }


    @Transactional
    public List<Podcast> importPodcast(Outline outline) throws SQLException, IOException {
        List<Podcast> newPodcasts = new ArrayList<>();

        Map<String, String> attributes = outline.getAttributes();
        if (attributes.containsKey("type") && attributes.get("type").equalsIgnoreCase("rss") && attributes.containsKey("xmlUrl")) {

            // we check if the feed already exists
            String url = attributes.get("xmlUrl");
            if (podcastRepository.findFirstByUrl(url).isEmpty()) {
                try {
                    Podcast podcast = new Podcast();
                    podcast.setUrl(url);
                    podcast = podcastParser.parseUrl(podcast);
                    newPodcasts.add(podcast);
                } catch (Exception e) {
                    log.warn("Couldnt parse podcast {}", url, e);
                }
            } else {
                log.info("User already has podcast {}", url);
            }
        }

        if (!outline.getSubElements().isEmpty()) {
            outline.getSubElements().forEach(outline1 -> {
                try {
                    newPodcasts.addAll(importPodcast(outline1));
                } catch (SQLException | IOException e) {
                    throw new RuntimeException(e);
                }
            });
        }

        return newPodcasts;
    }

    public void downloadEpisodes() {
        TransactionHelper.doInNewTransaction(platformTransactionManager, true, () -> {
            var episodes = episodeRepository.getEpisodeByPubDateMillisBefore(System.currentTimeMillis(), Sort.by(Sort.Direction.DESC, "pubDateMillis"), Limit.of(episodeCacheCount));

            for (var e : episodes) {
                try {
                    EpisodeUtils.downloadEpisode(e, episodeCacheFolder);
                } catch (IOException ex) {
                    log.error("Failed to download episode {}", e.getTitle(), ex);
                }
            }

            List<String> episodeHashes = episodes.stream().map(e -> Hashing.sha256().hashString(e.getAudioUrl(), StandardCharsets.UTF_8).toString()).toList();

            try {
                Files.list(episodeCacheFolder).forEach(path -> {
                    File file = path.getFileName().toFile();
                    String name = file.getName();
                    if (!episodeHashes.contains(name)) {
                        log.info("Deleting episode: {}", name);
                        try {
                            Files.deleteIfExists(path);
                        } catch (IOException e) {
                            log.error("Couldn't delete episode {}", name, e);
                        }
                    }
                });
            } catch (IOException e) {
                throw new RuntimeException(e);
            }

        });
    }

    @Transactional(readOnly = true)
    public List<Podcast> searchPodcasts(String query, int limit) {
        String tsQuery = Arrays.stream(query.trim().split("\\s+")).filter(s -> !s.isBlank()).map(s -> s.replaceAll("[^a-zA-Z0-9]", "") + ":*").collect(Collectors.joining(" & "));

        if (tsQuery.isBlank()) {
            return List.of();
        }
        return podcastRepository.searchPodcasts(tsQuery, limit);
    }
}
