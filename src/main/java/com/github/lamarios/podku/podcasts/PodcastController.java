/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import static com.github.lamarios.podku.utils.EndpointUtils.serveFile;

import be.ceau.opml.OpmlParseException;
import be.ceau.opml.OpmlWriteException;
import com.github.lamarios.podku.episodes.EpisodeService;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.transcripts.WhisperService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotNull;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

/**
 * REST API for managing subscriptions: listing, subscribing, importing/exporting feeds (OPML),
 * parsing a feed without subscribing, and searching.
 */
@RestController
@RequestMapping("/api/podcasts")
@Tag(name = "Podcasts")
public class PodcastController {
  private final PodcastService podcastService;
  private final EpisodeService episodeService;
  private final PodcastParser podcastParser;
  private final WhisperService whisperService;

  /**
   * @param podcastService subscription and feed management logic
   * @param episodeService used to kick off processing of newly imported podcasts
   * @param podcastParser parses raw feed content into {@link Podcast} objects
   * @param whisperService triggers transcription of processed episodes after import
   */
  @Autowired
  public PodcastController(
      PodcastService podcastService,
      EpisodeService episodeService,
      PodcastParser podcastParser,
      WhisperService whisperService) {
    this.podcastService = podcastService;
    this.episodeService = episodeService;
    this.podcastParser = podcastParser;
    this.whisperService = whisperService;
  }

  /**
   * Lists all subscribed podcasts as lightweight summaries.
   *
   * @return the list of subscribed podcasts (trimmed)
   */
  @GetMapping
  public List<PodcastLight> getPodcasts() {
    return podcastService.getPodcasts().stream().map(PodcastLight::new).toList();
  }

  /**
   * Subscribes to a podcast described by the given search result.
   *
   * @param result the search result describing the feed to subscribe to
   * @return the newly created {@link Podcast}
   */
  @PostMapping
  public Podcast subscribeToPodcast(@RequestBody SearchResult result) {
    Podcast newPodcast = null;
    newPodcast = podcastService.subscribe(result);
    return newPodcast;
  }

  /**
   * Parses a feed described by the given search result without persisting a subscription, returning
   * the populated {@link Podcast}.
   *
   * @param result the search result whose feed URL/collection should be parsed
   * @return the parsed podcast (not saved)
   */
  @PostMapping("/parse")
  public Podcast parsePodcast(@RequestBody SearchResult result) {
    Podcast podcast = new Podcast();
    podcast.setUrl(result.getFeedUrl());
    podcast.setName(result.getCollectionName());
    podcast.setArtworkUrl(result.getArtworkUrl());

    return podcastParser.parseUrl(podcast);
  }

  /**
   * Unsubscribes from the podcast with the given identifier.
   *
   * @param id identifier of the podcast to unsubscribe
   */
  @DeleteMapping("{id}")
  public void unsubsribe(@PathVariable String id) {
    podcastService.unsubscribe(id);
  }

  /**
   * Fetches a single full podcast by identifier.
   *
   * @param id path identifier of the podcast
   * @return the matching podcast, or {@code null} when none exists
   */
  @GetMapping("{id}")
  public Podcast getPodcast(@PathVariable String id) {
    return podcastService.getPodcast(id);
  }

  /**
   * Exports all subscribed feeds as an OPML document served as a downloadable file.
   *
   * @return the OPML export streamed as a file attachment
   * @throws IOException if the temporary export file cannot be written or served
   * @throws OpmlWriteException if the OPML document could not be produced
   */
  @GetMapping("/export")
  public ResponseEntity<@NotNull StreamingResponseBody> exportFeeds()
      throws IOException, OpmlWriteException {
    Path p = Files.createTempFile("ompl-export", ".opml");
    String opml = podcastService.exportPodcasts();

    try (PrintWriter printer = new PrintWriter(p.toFile().getAbsolutePath())) {
      IOUtils.write(opml, printer);
    }
    return serveFile(p);
  }

  /**
   * Imports podcasts from an uploaded OPML file. Each imported podcast is queued for processing
   * and, once all have finished, Whisper transcription is triggered.
   *
   * @param file the OPML upload to import
   * @return the list of newly added podcasts (lightweight summaries)
   * @throws SQLException if a database error occurs during import
   * @throws OpmlParseException if the uploaded file is not valid OPML
   * @throws IOException if the uploaded file cannot be read
   */
  @PostMapping(value = "/import", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public List<PodcastLight> importFeed(@RequestParam("file") MultipartFile file)
      throws SQLException, OpmlParseException, IOException {
    List<Podcast> added = new ArrayList<>();
    try {
      added = podcastService.importPodcasts(file);

      return added.stream().map(PodcastLight::new).toList();
    } finally {
      List<CompletableFuture<Podcast>> futures =
          added.stream().map(episodeService::processPodcast).toList();
      CompletableFuture<Void> combined =
          CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));

      combined.join();
      // then we process whisper
      whisperService.processEpisodeCron();
    }
  }

  /**
   * Searches for podcasts by name/collection.
   *
   * @param query free-text search term
   * @param limit maximum number of results to return
   * @return matching podcasts (lightweight summaries)
   */
  @GetMapping("/search")
  public List<PodcastLight> search(
      @RequestParam("query") String query, @RequestParam("limit") int limit) {
    return podcastService.searchPodcasts(query, limit).stream().map(PodcastLight::new).toList();
  }
}
