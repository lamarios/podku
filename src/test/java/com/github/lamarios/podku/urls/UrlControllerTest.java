package com.github.lamarios.podku.urls;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeFile;
import com.github.lamarios.podku.episodes.EpisodeFileType;
import com.github.lamarios.podku.episodes.EpisodeUtils;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.utils.FastUrlCrypto;
import com.google.common.hash.Hashing;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

public class UrlControllerTest extends TestContainerTest {

  @Autowired private UrlController urlController;

  @Value("${podku.episodes.cache-dir:./episode-cache}")
  private String episodeCacheFolder;

  @Value("${image-proxy.cache-dir:./image-cache}")
  private String imageCacheFolder;

  @Test
  public void testProxyAudioUpstream() throws Exception {
    String audioUrl = getBaseUrl() + "/mock/audio.mp3";
    String encryptedUrl = FastUrlCrypto.instance.encrypt(audioUrl);

    MockHttpServletRequest request = new MockHttpServletRequest();
    ResponseEntity<StreamingResponseBody> response =
        urlController.proxyAudio(encryptedUrl, null, request);

    assertEquals(HttpStatus.OK, response.getStatusCode());
    assertNotNull(response.getBody());

    ByteArrayOutputStream out = new ByteArrayOutputStream();
    response.getBody().writeTo(out);
    byte[] data = out.toByteArray();
    assertTrue(data.length > 0);
  }

  @Test
  public void testProxyAudioFromCacheWithRange() throws Exception {
    String audioUrl = getBaseUrl() + "/mock/cached-audio.mp3";
    String hash = Hashing.sha256().hashString(audioUrl, StandardCharsets.UTF_8).toString();
    Path cachedFile = Paths.get(episodeCacheFolder).resolve(hash);

    byte[] dummyBytes = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".getBytes(StandardCharsets.UTF_8);
    Files.write(cachedFile, dummyBytes);

    try {
      String encryptedUrl = FastUrlCrypto.instance.encrypt(audioUrl);

      // Full content from cache
      MockHttpServletRequest request = new MockHttpServletRequest();
      ResponseEntity<StreamingResponseBody> response =
          urlController.proxyAudio(encryptedUrl, null, request);

      assertEquals(HttpStatus.OK, response.getStatusCode());
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      response.getBody().writeTo(out);
      assertArrayEquals(dummyBytes, out.toByteArray());

      // Range request from cache
      ResponseEntity<StreamingResponseBody> rangeResponse =
          urlController.proxyAudio(encryptedUrl, "bytes=0-9", request);

      assertEquals(HttpStatus.PARTIAL_CONTENT, rangeResponse.getStatusCode());
      ByteArrayOutputStream rangeOut = new ByteArrayOutputStream();
      rangeResponse.getBody().writeTo(rangeOut);
      assertEquals("0123456789", rangeOut.toString(StandardCharsets.UTF_8));
    } finally {
      Files.deleteIfExists(cachedFile);
    }
  }

  @Test
  public void testGetImageAndRevalidation() throws Exception {
    String imageUrl = getBaseUrl() + "/mock/artwork.png";
    String encryptedUrl = FastUrlCrypto.instance.encrypt(imageUrl);

    // Initial fetch from upstream
    ResponseEntity<StreamingResponseBody> response = urlController.getImage(encryptedUrl, null);
    assertEquals(HttpStatus.OK, response.getStatusCode());
    assertNotNull(response.getBody());

    ByteArrayOutputStream out = new ByteArrayOutputStream();
    response.getBody().writeTo(out);
    assertTrue(out.size() > 0);

    String etag = response.getHeaders().getETag();
    assertNotNull(etag);

    // Revalidation with matching ETag should return 304 Not Modified
    ResponseEntity<StreamingResponseBody> notModifiedResponse =
        urlController.getImage(encryptedUrl, etag);
    assertEquals(HttpStatus.NOT_MODIFIED, notModifiedResponse.getStatusCode());
  }

  @Test
  public void testGetImageInvalidUrl() throws Exception {
    String invalidUrl = "ftp://invalid-scheme.com/test.png";
    String encryptedUrl = FastUrlCrypto.instance.encrypt(invalidUrl);

    ResponseEntity<StreamingResponseBody> response = urlController.getImage(encryptedUrl, null);
    assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
  }

  @Test
  public void testDownloadedEpisodeMediaIsServedFromCache() throws Exception {
    Podcast podcast = new Podcast();
    podcast.setName("Cache");
    Episode episode = new Episode();
    episode.setTitle("Cached episode");
    episode.setPodcast(podcast);
    EpisodeFile media = new EpisodeFile();
    media.setType(EpisodeFileType.audio);
    media.setUrl(getBaseUrl() + "/mock/audio.mp3");
    media.setEpisode(episode);

    Path cachedFile = EpisodeUtils.downloadEpisode(media, Paths.get(episodeCacheFolder));

    try {
      assertEquals(EpisodeUtils.mediaCacheKey(media), cachedFile.getFileName().toString());
      assertEquals(2048, Files.size(cachedFile));
      // overwrite the cached copy to tell it apart from the upstream file
      byte[] cachedBytes = "from the cache".getBytes(StandardCharsets.UTF_8);
      Files.write(cachedFile, cachedBytes);

      ResponseEntity<StreamingResponseBody> response =
          urlController.proxyAudio(media.getUrlEncrypted(), null, new MockHttpServletRequest());

      assertEquals(HttpStatus.OK, response.getStatusCode());
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      response.getBody().writeTo(out);
      assertArrayEquals(cachedBytes, out.toByteArray());
    } finally {
      Files.deleteIfExists(cachedFile);
    }
  }
}
