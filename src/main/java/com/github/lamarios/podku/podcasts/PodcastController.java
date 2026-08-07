package com.github.lamarios.podku.podcasts;

import be.ceau.opml.OpmlParseException;
import be.ceau.opml.OpmlWriteException;
import com.github.lamarios.podku.episodes.EpisodeService;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.transcripts.WhisperService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotNull;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import static com.github.lamarios.podku.utils.EndpointUtils.serveFile;

@RestController
@RequestMapping("/api/podcasts")
@Tag(name = "Podcasts")
public class PodcastController {
    private final PodcastService podcastService;
    private final EpisodeService episodeService;
    private final PodcastParser podcastParser;
    private final WhisperService whisperService;

    @Autowired
    public PodcastController(PodcastService podcastService, EpisodeService episodeService, PodcastParser podcastParser, WhisperService whisperService) {
        this.podcastService = podcastService;
        this.episodeService = episodeService;
        this.podcastParser = podcastParser;
        this.whisperService = whisperService;
    }

    @GetMapping
    public List<PodcastLight> getPodcasts() {
        return podcastService.getPodcasts().stream().map(PodcastLight::new).toList();
    }

    @PostMapping
    public Podcast subscribeToPodcast(@RequestBody SearchResult result) {
        Podcast newPodcast = null;
        newPodcast = podcastService.subscribe(result);
        return newPodcast;
    }

    @PostMapping("/parse")
    public Podcast parsePodcast(@RequestBody SearchResult result) {
        Podcast podcast = new Podcast();
        podcast.setUrl(result.getFeedUrl());
        podcast.setName(result.getCollectionName());
        podcast.setArtworkUrl(result.getArtworkUrl());

        return podcastParser.parseUrl(podcast);
    }

    @DeleteMapping("{id}")
    public void unsubsribe(@PathVariable String id) {
        podcastService.unsubscribe(id);
    }

    @GetMapping("{id}")
    public Podcast getPodcast(@PathVariable String id) {
        return podcastService.getPodcast(id);
    }


    @GetMapping("/export")
    public ResponseEntity<@NotNull StreamingResponseBody> exportFeeds() throws IOException, OpmlWriteException {
        Path p = Files.createTempFile("ompl-export", ".opml");
        String opml = podcastService.exportPodcasts();

        try (PrintWriter printer = new PrintWriter(p.toFile().getAbsolutePath())) {
            IOUtils.write(opml, printer);

        }
        return serveFile(p);
    }


    @PostMapping(value = "/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public List<PodcastLight> importFeed(@RequestParam("file") MultipartFile file) throws SQLException, OpmlParseException, IOException {
        List<Podcast> added = new ArrayList<>();
        try {
            added = podcastService.importPodcasts(file);

            return added.stream().map(PodcastLight::new).toList();
        } finally {
            List<CompletableFuture<Podcast>> futures = added.stream().map(episodeService::processPodcast).toList();
            CompletableFuture<Void> combined = CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));

            combined.join();
            // then we process whisper
            whisperService.processEpisodeCron();
        }
    }


    @GetMapping("/search")
    public List<PodcastLight> search(@RequestParam("query") String query, @RequestParam("limit") int limit) {
        return podcastService.searchPodcasts(query, limit).stream().map(PodcastLight::new).toList();
    }

}
