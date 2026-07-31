package com.github.lamarios.podku.podcasts;

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

import java.util.List;
import java.util.Optional;
import java.util.UUID;

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
}
