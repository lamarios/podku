package com.github.lamarios.podku.episodes;

import com.github.lamarios.podku.websockets.PlaybackProgress;
import com.github.lamarios.podku.websockets.WebSocketSessionManager;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;

import org.springframework.http.HttpHeaders; // <-- make sure this is the one imported

import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/api/episodes")
@Tag(name = "Episodes")
public class EpisodeController {

    static {
        System.setProperty("jdk.httpclient.redirects.retrylimit", "50");
    }

    private final Logger log = LogManager.getLogger();
    private static final Set<String> FORWARDABLE_REQUEST_HEADERS =
            Set.of("range", "accept", "user-agent");

    // Headers Spring/the servlet container manage themselves — don't copy these
    // from the upstream response, or you'll get duplicate/conflicting values.
    private static final Set<String> SKIP_RESPONSE_HEADERS =
            Set.of("transfer-encoding", "connection", "content-encoding", "content-length", "access-control-allow-methods", "access-control-allow-origin", "access-control-allow-headers");

    private final HttpClient httpClient = HttpClient.newBuilder()
            .followRedirects(HttpClient.Redirect.ALWAYS)
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    private static final Set<String> FORWARDABLE_RESPONSE_HEADERS =
            Set.of("content-type", "content-length", "content-range", "accept-ranges",
                    "cache-control", "etag", "last-modified", "expires");



    private final EpisodeService episodeService;

    @Autowired
    public EpisodeController(EpisodeService episodeService) {
        this.episodeService = episodeService;
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
        WebSocketSessionManager.sendToUsers(progress);
    }


    @GetMapping("/audio-proxy")
    public ResponseEntity<StreamingResponseBody> proxyAudio(
            @RequestParam("url") String audioUrl,
            HttpServletRequest request) throws InterruptedException {

        try {
            HttpRequest.Builder upstreamBuilder = HttpRequest.newBuilder(URI.create(audioUrl)).GET();

            Collections.list(request.getHeaderNames()).forEach(name -> {
                System.out.println(name + ": " + request.getHeader(name));
                if (FORWARDABLE_REQUEST_HEADERS.contains(name.toLowerCase())) {
                    upstreamBuilder.header(name, request.getHeader(name));
                }
            });

            long start = System.currentTimeMillis();
            log.info("Starting upstream request to {}", audioUrl);
            HttpResponse<InputStream> upstreamResponse;
            try {
                upstreamResponse = httpClient.send(
                        upstreamBuilder.build(),
                        HttpResponse.BodyHandlers.ofInputStream()
                );
            } catch (IOException e) {
                return ResponseEntity.status(HttpStatus.BAD_GATEWAY).build();
            }

            log.info("Upstream response received after {}ms, status={}",
                    System.currentTimeMillis() - start, upstreamResponse.statusCode());

            HttpHeaders headers = new HttpHeaders();
            upstreamResponse.headers().map().forEach((key, values) -> {
                if (FORWARDABLE_RESPONSE_HEADERS.contains(key.toLowerCase())) {
                    headers.addAll(key, values);
                }
            });

            StreamingResponseBody body = outputStream -> {
                try (InputStream in = upstreamResponse.body()) {
                    in.transferTo(outputStream);
                }
            };

            return ResponseEntity.status(upstreamResponse.statusCode())
                    .headers(headers)
                    .body(body);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
