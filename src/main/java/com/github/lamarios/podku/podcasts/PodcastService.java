package com.github.lamarios.podku.podcasts;

import be.ceau.opml.OpmlParseException;
import be.ceau.opml.OpmlParser;
import be.ceau.opml.OpmlWriteException;
import be.ceau.opml.OpmlWriter;
import be.ceau.opml.entity.Body;
import be.ceau.opml.entity.Head;
import be.ceau.opml.entity.Opml;
import be.ceau.opml.entity.Outline;
import com.github.lamarios.podku.episodes.EpisodeService;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.utils.TransactionHelper;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.domain.Sort;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class PodcastService {
    private final Logger log = LogManager.getLogger();
    private final PodcastRepository podcastRepository;
    private final EpisodeService episodeService;
    private final PlatformTransactionManager platformTransactionManager;

    @Autowired
    public PodcastService(PodcastRepository podcastRepository, EpisodeService episodeService, @Qualifier("transactionManager") PlatformTransactionManager platformTransactionManager) {
        this.podcastRepository = podcastRepository;
        this.episodeService = episodeService;
        this.platformTransactionManager = platformTransactionManager;
    }


    @Transactional(readOnly = true)
    List<Podcast> getPodcasts() {
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

                podcast = new PodcastParser().parseUrl(podcast);

                podcastRepository.save(podcast);
                episodeService.processPodcast(podcast);

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


    @Scheduled(cron = "@daily")
    public void refreshPodcasts() {
        var parser = new PodcastParser();
        TransactionHelper.doInNewTransaction(platformTransactionManager, false, () -> {
            var podcasts = podcastRepository.findAll();
            for (var podcast : podcasts) {
                TransactionHelper.doInNewTransaction(platformTransactionManager, false, () -> {
                    Podcast parsed = null;
                    try {
                        log.info("Refreshing podcast {}", podcast.getName());

                        parsed = parser.parseUrl(podcast);
                        podcastRepository.save(parsed);
                    } finally {
                        if (parsed != null) {
                            episodeService.processPodcast(parsed);
                        }
                    }
                });
            }
        });
    }

    @Transactional(readOnly = true)
    public String exportPodcasts() throws OpmlWriteException {
        List<Podcast> feeds = podcastRepository.findAll();

        Head head = new Head("Podku", LocalDateTime.now()
                .toString(), null, null, null, null, null, null, null, null, null, null, null);

        List<Outline> outlines = feeds.stream()
                .map(feed -> new Outline(Map.of("type", "rss", "xmlUrl", feed.getUrl(), "title", feed.getName()), Collections.emptyList()))
                .toList();

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
        if (attributes.containsKey("type") && attributes.get("type")
                .equalsIgnoreCase("rss") && attributes.containsKey("xmlUrl")) {

            // we check if the feed already exists
            String url = attributes.get("xmlUrl");
            if (podcastRepository.findFirstByUrl(url).isEmpty()) {
                try {
                    Podcast podcast = new Podcast();
                    podcast.setUrl(url);
                    podcast = new PodcastParser().parseUrl(podcast);
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
}
