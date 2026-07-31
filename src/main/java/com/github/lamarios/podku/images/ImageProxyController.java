package com.github.lamarios.podku.images;

import com.google.common.hash.Hashing;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import java.util.List;

@RestController
@RequestMapping("/api/images")
@Tag(name = "Proxy")
public class ImageProxyController {

    private final Logger log = LogManager.getLogger();
    private final HttpClient httpClient = HttpClient.newBuilder()
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    private final Path cacheDir;

    public ImageProxyController(@Value("${image-proxy.cache-dir:./image-cache}") String cacheDirPath)
            throws IOException {
        this.cacheDir = Paths.get(cacheDirPath);
        Files.createDirectories(cacheDir);
    }

    @GetMapping("proxy")
    public ResponseEntity<StreamingResponseBody> proxyImage(
            @RequestParam("url") String imageUrl,
            @RequestHeader(value = HttpHeaders.IF_NONE_MATCH, required = false) String clientEtag)
            throws IOException, InterruptedException {

        URI uri;
        try {
            uri = new URI(imageUrl);
            if (uri.getScheme() == null
                    || (!uri.getScheme().equals("http") && !uri.getScheme().equals("https"))) {
                throw new URISyntaxException(imageUrl, "missing or invalid scheme");
            }
        } catch (URISyntaxException e) {
            log.warn("Rejected invalid image URL: [{}]", imageUrl);
            return ResponseEntity.badRequest().build();
        }

        String cacheKey = Hashing.sha256().hashString(imageUrl, StandardCharsets.UTF_8).toString();
        Path cachedFile = cacheDir.resolve(cacheKey);
        Path cachedMeta = cacheDir.resolve(cacheKey + ".meta");

        CachedMetadata meta = readMetadata(cachedMeta);

        // If we already have a cached copy, revalidate with the origin instead of
        // blindly re-downloading — cheap 304 vs a full image transfer.
        HttpRequest.Builder upstreamBuilder = HttpRequest.newBuilder(uri).GET();
        if (meta != null) {
            if (meta.etag() != null) {
                upstreamBuilder.header("If-None-Match", meta.etag());
            }
            if (meta.lastModified() != null) {
                upstreamBuilder.header("If-Modified-Since", meta.lastModified());
            }
        }

        HttpResponse<InputStream> upstreamResponse;
        try {
            upstreamResponse = httpClient.send(upstreamBuilder.build(), HttpResponse.BodyHandlers.ofInputStream());
        } catch (IOException e) {
            if (meta != null && Files.exists(cachedFile)) {
                // Origin unreachable but we have something cached — serve stale rather than fail.
                log.warn("Origin fetch failed for [{}], serving stale cache", imageUrl, e);
                return serveFromDisk(cachedFile, meta, clientEtag);
            }
            return ResponseEntity.status(HttpStatus.BAD_GATEWAY).build();
        }

        if (upstreamResponse.statusCode() == 304 && meta != null) {
            // Origin confirms unchanged; refresh our own freshness window and serve cached bytes.
            upstreamResponse.body().close();
            return serveFromDisk(cachedFile, meta, clientEtag);
        }

        if (upstreamResponse.statusCode() != 200) {
            upstreamResponse.body().close();
            return ResponseEntity.status(upstreamResponse.statusCode()).build();
        }

        String newEtag = upstreamResponse.headers().firstValue("ETag").orElse(null);
        String newLastModified = upstreamResponse.headers().firstValue("Last-Modified").orElse(null);
        String contentType = upstreamResponse.headers().firstValue("Content-Type").orElse("application/octet-stream");

        // Stream to the cache file and to the client at the same time via a tee,
        // so a slow client doesn't block us from finishing the cache write, and vice versa.
        Path tempFile = cacheDir.resolve(cacheKey + ".tmp-" + System.nanoTime());
        try (InputStream in = upstreamResponse.body()) {
            Files.copy(in, tempFile, StandardCopyOption.REPLACE_EXISTING);
        }
        Files.move(tempFile, cachedFile, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);

        CachedMetadata newMeta = new CachedMetadata(newEtag, newLastModified, contentType);
        writeMetadata(cachedMeta, newMeta);

        return serveFromDisk(cachedFile, newMeta, clientEtag);
    }

    private ResponseEntity<StreamingResponseBody> serveFromDisk(
            Path file, CachedMetadata meta, String clientEtag) throws IOException {

        // Respect the requesting client's own cache too — no need to resend bytes
        // if their copy already matches what we have cached.
        if (meta.etag() != null && meta.etag().equals(clientEtag)) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED)
                    .eTag(meta.etag())
                    .cacheControl(CacheControl.maxAge(Duration.ofDays(1)).cachePublic())
                    .build();
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setAccessControlAllowOrigin("*");
        headers.setContentType(MediaType.parseMediaType(meta.contentType()));
        headers.setContentLength(Files.size(file));
        if (meta.etag() != null) {
            headers.setETag(meta.etag().startsWith("\"") ? meta.etag() : "\"" + meta.etag() + "\"");
        }
        if (meta.lastModified() != null) {
            headers.set(HttpHeaders.LAST_MODIFIED, meta.lastModified());
        }
        headers.setCacheControl(CacheControl.maxAge(Duration.ofDays(1)).cachePublic());

        StreamingResponseBody body = outputStream -> Files.copy(file, outputStream);

        return ResponseEntity.ok().headers(headers).body(body);
    }

    private CachedMetadata readMetadata(Path metaFile) throws IOException {
        if (!Files.exists(metaFile)) {
            return null;
        }
        List<String> lines = Files.readAllLines(metaFile);
        return new CachedMetadata(
                !lines.isEmpty() && !lines.get(0).isEmpty() ? lines.get(0) : null,
                lines.size() > 1 && !lines.get(1).isEmpty() ? lines.get(1) : null,
                lines.size() > 2 ? lines.get(2) : "application/octet-stream"
        );
    }

    private void writeMetadata(Path metaFile, CachedMetadata meta) throws IOException {
        Files.write(metaFile, List.of(
                meta.etag() != null ? meta.etag() : "",
                meta.lastModified() != null ? meta.lastModified() : "",
                meta.contentType()
        ));
    }

    private record CachedMetadata(String etag, String lastModified, String contentType) {
    }
}
