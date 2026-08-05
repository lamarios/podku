package com.github.lamarios.podku.urls;

import com.google.common.hash.Hashing;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
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
import java.util.Collections;
import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("/media")
@Tag(name = "Media")
public class UrlController {

    private final Logger log = LogManager.getLogger();

    private final Path cacheDir;
    private final UrlService urlService;

    static {
        System.setProperty("jdk.httpclient.redirects.retrylimit", "50");
    }
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
    private final Path episodeCacheFolder;


    public UrlController(@Value("${image-proxy.cache-dir:./image-cache}") String cacheDirPath, UrlService urlService, @Value("${podku.episodes.cache-dir:./episode-cache}") String episodeCacheFolder)
            throws IOException {
        this.cacheDir = Paths.get(cacheDirPath);
        Files.createDirectories(cacheDir);
        this.urlService = urlService;
        Path p = Path.of(episodeCacheFolder);
        if (!p.toFile().exists()) {
            p.toFile().mkdirs();
        }

        this.episodeCacheFolder = p;
    }

    @GetMapping("/audio/{hash}")
    public ResponseEntity<StreamingResponseBody> proxyAudio(
            @PathVariable("hash") String hash,
            @RequestHeader(value = "Range", required = false) String rangeHeader,
            HttpServletRequest request) throws InterruptedException {

        try {

            var urlOpt = urlService.getUrl(hash);
            if (urlOpt.isEmpty()) {
                return ResponseEntity.status(404).build();
            }

            String audioUrl = urlOpt.get();

            // we check if we have the file in cache first
            var filePath = episodeCacheFolder.resolve(hash);
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




    @GetMapping("image/{hash}")
    public ResponseEntity<StreamingResponseBody> getImage(
            @PathVariable("hash") String hash,
            @RequestHeader(value = HttpHeaders.IF_NONE_MATCH, required = false) String clientEtag)
            throws IOException, InterruptedException {

        var urlOpt = urlService.getUrl(hash);
        if (urlOpt.isEmpty()) {
            return ResponseEntity.status(404).build();
        }

        String imageUrl = urlOpt.get();

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


        Path cachedFile = cacheDir.resolve(hash);
        Path cachedMeta = cacheDir.resolve(hash + ".meta");

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
        Path tempFile = cacheDir.resolve(hash + ".tmp-" + System.nanoTime());
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
