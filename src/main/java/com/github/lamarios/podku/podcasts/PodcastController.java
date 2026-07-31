package com.github.lamarios.podku.podcasts;

import com.github.lamarios.podku.episodes.EpisodeService;
import com.github.lamarios.podku.search.SearchResult;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/podcasts")
@Tag(name = "Podcasts")
public class PodcastController {


    private final PodcastService podcastService;
    private final EpisodeService episodeService;

    @Autowired
    public PodcastController(PodcastService podcastService, EpisodeService episodeService) {
        this.podcastService = podcastService;
        this.episodeService = episodeService;
    }

    @GetMapping
    public List<PodcastLight> getPodcasts() {
        return podcastService.getPodcasts().stream().map(PodcastLight::new).toList();
    }

    @PostMapping
    public Podcast subscribeToPodcast(@RequestBody SearchResult result) {
        Podcast newPodcast = null;
        try {
            newPodcast = podcastService.subscribe(result);
            return newPodcast;
        } finally {
            if (newPodcast != null) {
                episodeService.processPodcast(newPodcast);
            }
        }
    }

    @PostMapping("/parse")
    public Podcast parsePodcast(@RequestBody SearchResult result) {
        Podcast podcast = new Podcast();
        podcast.setUrl(result.getFeedUrl());
        podcast.setName(result.getCollectionName());
        podcast.setArtworkUrl(result.getArtworkUrl());

        return new PodcastParser().parseUrl(podcast);
    }

    @DeleteMapping("{id}")
    public void unsubsribe(@PathVariable String id) {
        podcastService.unsubscribe(id);
    }

    @GetMapping("{id}")
    public Podcast getPodcast(@PathVariable String id) {
        return podcastService.getPodcast(id);
    }

}
