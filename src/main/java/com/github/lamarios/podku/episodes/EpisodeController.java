package com.github.lamarios.podku.episodes;

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
    private final Path episodeCacheFolder;

    @Autowired
    public EpisodeController(EpisodeService episodeService, @Value("${podku.episodes.cache-dir:./episode-cache}") String episodeCacheFolder) {
        this.episodeService = episodeService;

        Path p = Path.of(episodeCacheFolder);
        if (!p.toFile().exists()) {
            p.toFile().mkdirs();
        }

        this.episodeCacheFolder = p;
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
            @RequestHeader(value = "Range", required = false) String rangeHeader,
            HttpServletRequest request) throws InterruptedException {

        try {

            // we check if we have the file in cache first
            String urlHash = Hashing.sha256().hashString(audioUrl, StandardCharsets.UTF_8).toString();
            var filePath = episodeCacheFolder.resolve(urlHash);
            if (Files.exists(filePath)) {
                return serveFileFromCache(filePath, rangeHeader);
            } else {

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

                HttpHeaders outgoingHeaders = new HttpHeaders();
                upstreamResponse.headers().map().forEach((key, values) -> {
                    if (FORWARDABLE_RESPONSE_HEADERS.contains(key.toLowerCase())) {
                        outgoingHeaders.addAll(key, values);
                    }
                });

                StreamingResponseBody body = outputStream -> {
                    try (InputStream in = upstreamResponse.body()) {
                        in.transferTo(outputStream);
                    }
                };

                return ResponseEntity.status(upstreamResponse.statusCode())
                        .headers(outgoingHeaders)
                        .body(body);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    /**
     * serve file from local storage
     *
     * @param file
     * @param rangeHeader
     * @return
     * @throws IOException
     */
    private ResponseEntity<StreamingResponseBody> serveFileFromCache(Path file, String rangeHeader) throws IOException {
        log.info("Serving file from local storage {}, range {}", file, rangeHeader);
        var contentLength = Files.size(file);
        long start = 0;
        long end = contentLength - 1;
        HttpStatus status = HttpStatus.OK;

        if (rangeHeader != null) {
            HttpRange range = HttpRange.parseRanges(rangeHeader).get(0);
            start = range.getRangeStart(contentLength);
            end = range.getRangeEnd(contentLength);
            status = HttpStatus.PARTIAL_CONTENT;
        }

        long finalStart = start;
        long rangeLength = end - start + 1;

        StreamingResponseBody body = outputStream -> {
            try (RandomAccessFile raf = new RandomAccessFile(file.toFile(), "r")) {
                raf.seek(finalStart);
                byte[] buffer = new byte[8192];
                long bytesLeft = rangeLength;
                int read;
                while (bytesLeft > 0 && (read = raf.read(buffer, 0, (int) Math.min(buffer.length, bytesLeft))) != -1) {
                    outputStream.write(buffer, 0, read);
                    bytesLeft -= read;
                }
            }
        };

        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.ACCEPT_RANGES, "bytes");
        headers.setContentLength(rangeLength);
        if (status == HttpStatus.PARTIAL_CONTENT) {
            headers.set(HttpHeaders.CONTENT_RANGE, "bytes " + start + "-" + end + "/" + contentLength);
        }
        try {
            headers.setContentType(MediaType.parseMediaType(Files.probeContentType(file)));
        } catch (Exception e) {
            headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        }
        return ResponseEntity.status(status).headers(headers).body(body);

    }
}
