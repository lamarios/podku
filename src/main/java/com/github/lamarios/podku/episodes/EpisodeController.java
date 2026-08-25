/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.websockets.PlaybackProgress;
import com.github.lamarios.podku.websockets.WebSocketSessionManager;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

/** REST API for episodes: listing, lookup, playback progress updates and full-text search. */
@RestController
@RequestMapping("/api/episodes")
@Tag(name = "Episodes")
public class EpisodeController {
  private final Logger log = LogManager.getLogger();
  private final EpisodeService episodeService;
  private final WebSocketSessionManager webSocketSessionManager;

  /**
   * @param episodeService service providing episode data and playback state
   * @param webSocketSessionManager manager used to fan playback events out to connected clients
   */
  @Autowired
  public EpisodeController(
      EpisodeService episodeService, WebSocketSessionManager webSocketSessionManager) {
    this.episodeService = episodeService;
    this.webSocketSessionManager = webSocketSessionManager;
  }

  /**
   * Lists episodes published before a given point in time.
   *
   * @param before optional epoch-milliseconds timestamp; defaults to "now" when absent
   * @param pageSize maximum number of episodes to return (default 20)
   * @return up to {@code pageSize} episodes, newest first
   */
  @GetMapping
  public List<Episode> getEpisodes(
      @RequestParam(required = false) Long before,
      @RequestParam(required = false, defaultValue = "20") Integer pageSize) {
    long effectiveDate = before != null ? before : System.currentTimeMillis();

    return episodeService.getEpisodes(effectiveDate, pageSize);
  }

  /**
   * Fetches a single episode by identifier.
   *
   * @param id path identifier of the episode
   * @return the matching episode
   */
  @GetMapping("{id}")
  public Episode getEpisode(@PathVariable String id) {
    return episodeService.getEpisode(id);
  }

  /**
   * Persists a playback-progress update for an episode.
   *
   * @param progress the playback state (episode, position, etc.) to record
   */
  @PostMapping("setProgress")
  public void setProgress(@RequestBody PlaybackProgress progress) {
    episodeService.setProgress(progress);
  }

  /**
   * Broadcasts a playback-start event to every connected WebSocket client.
   *
   * @param progress the playback state to relay to other devices
   */
  @PostMapping("startPlayback")
  public void startPlayback(@RequestBody PlaybackProgress progress) {
    webSocketSessionManager.sendToUsers(progress);
  }

  /**
   * Full-text search over episodes.
   *
   * @param query free-text search term
   * @param limit maximum number of results to return
   * @return matching episodes with a relevance score
   */
  @GetMapping("/search")
  public List<EpisodeSearchResult> search(
      @RequestParam("query") String query, @RequestParam("limit") int limit) {
    return episodeService.searchPodcasts(query, limit);
  }

  /**
   * Applies a batch of playback-progress updates in a single transaction.
   *
   * @param progresses map of episode id to offline progress to apply
   * @return {@code true} when the batch was applied successfully
   */
  @PostMapping("/setProgressesBatch")
  public boolean updateProgresses(@RequestBody Map<String, OfflineProgress> progresses) {
    return episodeService.updateProgresses(progresses);
  }
}
