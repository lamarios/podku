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

@RestController
@RequestMapping("/api/episodes")
@Tag(name = "Episodes")
public class EpisodeController {
  private final Logger log = LogManager.getLogger();
  private final EpisodeService episodeService;
  private final WebSocketSessionManager webSocketSessionManager;

  @Autowired
  public EpisodeController(
      EpisodeService episodeService, WebSocketSessionManager webSocketSessionManager) {
    this.episodeService = episodeService;
    this.webSocketSessionManager = webSocketSessionManager;
  }

  @GetMapping
  public List<Episode> getEpisodes(
      @RequestParam(required = false) Long before,
      @RequestParam(required = false, defaultValue = "20") Integer pageSize) {
    long effectiveDate = before != null ? before : System.currentTimeMillis();

    return episodeService.getEpisodes(effectiveDate, pageSize);
  }

  @GetMapping("{id}")
  public Episode getEpisode(@PathVariable String id) {
    return episodeService.getEpisode(id);
  }

  @PostMapping("setProgress")
  public void setProgress(@RequestBody PlaybackProgress progress) {
    episodeService.setProgress(progress);
  }

  @PostMapping("startPlayback")
  public void startPlayback(@RequestBody PlaybackProgress progress) {
    webSocketSessionManager.sendToUsers(progress);
  }

  @GetMapping("/search")
  public List<EpisodeSearchResult> search(
      @RequestParam("query") String query, @RequestParam("limit") int limit) {
    return episodeService.searchPodcasts(query, limit);
  }

  @PostMapping("/setProgressesBatch")
  public boolean updateProgresses(@RequestBody Map<String, OfflineProgress> progresses) {
    return episodeService.updateProgresses(progresses);
  }
}
