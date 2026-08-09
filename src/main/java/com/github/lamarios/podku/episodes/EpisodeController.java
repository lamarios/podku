package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.podcasts.PodcastLight;
import com.github.lamarios.podku.websockets.PlaybackProgress;
import com.github.lamarios.podku.websockets.WebSocketSessionManager;
import com.google.common.hash.Hashing;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.net.URI;
import java.net.http.HttpClient;

import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/episodes")
@Tag(name = "Episodes")
public class EpisodeController {


    private final Logger log = LogManager.getLogger();


    private final EpisodeService episodeService;
    private final WebSocketSessionManager webSocketSessionManager;

    @Autowired
    public EpisodeController(EpisodeService episodeService, WebSocketSessionManager webSocketSessionManager) {
        this.episodeService = episodeService;
        this.webSocketSessionManager = webSocketSessionManager;
    }

    @GetMapping
    public List<Episode> getEpisodes(@RequestParam(required = false) Long before, @RequestParam(required = false, defaultValue = "20") Integer pageSize) {
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
    public List<Episode> search(@RequestParam("query") String query, @RequestParam("limit") int limit) {
        return episodeService.searchPodcasts(query, limit);
    }


}
