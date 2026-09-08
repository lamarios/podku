package com.github.lamarios.podku.mock;

import jakarta.servlet.http.HttpServletRequest;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.imageio.ImageIO;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Test-only controller exposing mock podcast feeds, transcripts, chapters, audio, and images. */
@RestController
@RequestMapping("/mock")
public class MockFeedController {

  private static final String ETAG_VALUE = "\"mock-artwork-etag\"";

  private String getBaseUrl(HttpServletRequest request) {
    return request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
  }

  @GetMapping(value = "/feed.xml", produces = MediaType.APPLICATION_XML_VALUE)
  public String getPodcastFeed(HttpServletRequest request) {
    String base = getBaseUrl(request);
    return """
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0"
             xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
             xmlns:podcast="https://podcastindex.org/namespace/1.0">
          <channel>
            <title>Mock Tech Podcast</title>
            <link>%s/mock/podcast</link>
            <description>A test podcast about modern software engineering</description>
            <itunes:author>Podku Team</itunes:author>
            <itunes:image href="%s/mock/artwork.png"/>
            <podcast:person role="host" group="cast">Alice Smith</podcast:person>
            <item>
              <title>Episode 1: Getting Started with Podku</title>
              <description>In this episode we introduce Podku architecture.</description>
              <guid isPermaLink="false">mock-ep-1</guid>
              <pubDate>Mon, 01 Jan 2024 12:00:00 GMT</pubDate>
              <enclosure url="%s/mock/audio.mp3" length="4096" type="audio/mpeg"/>
              <itunes:duration>1800</itunes:duration>
              <podcast:chapters url="%s/mock/chapters.json" type="application/json+chapters"/>
              <podcast:transcript url="%s/mock/transcript.vtt" type="text/vtt" language="en"/>
              <podcast:transcript url="%s/mock/transcript.srt" type="application/x-subrip" language="fr"/>
              <podcast:person role="guest">Bob Jones</podcast:person>
            </item>
            <item>
              <title>Episode 2: Deep Dive into Transcripts</title>
              <description>Discussing VTT and SRT parsing and full-text search.</description>
              <guid isPermaLink="false">mock-ep-2</guid>
              <pubDate>Sun, 31 Dec 2023 12:00:00 GMT</pubDate>
              <enclosure url="%s/mock/audio.mp3" length="4096" type="audio/mpeg"/>
              <itunes:duration>2400</itunes:duration>
            </item>
          </channel>
        </rss>
        """
        .formatted(base, base, base, base, base, base, base);
  }

  @GetMapping(value = "/feed2.xml", produces = MediaType.APPLICATION_XML_VALUE)
  public String getSecondPodcastFeed(HttpServletRequest request) {
    String base = getBaseUrl(request);
    return """
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0"
             xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
             xmlns:podcast="https://podcastindex.org/namespace/1.0">
          <channel>
            <title>Second Mock Feed</title>
            <link>%s/mock/podcast2</link>
            <description>Another podcast for import testing</description>
            <itunes:author>Jane Doe</itunes:author>
            <itunes:image href="%s/mock/artwork.png"/>
            <item>
              <title>Feed 2 Episode 1</title>
              <description>Second feed episode</description>
              <guid isPermaLink="false">mock-feed2-ep-1</guid>
              <pubDate>Tue, 02 Jan 2024 12:00:00 GMT</pubDate>
              <enclosure url="%s/mock/audio.mp3" length="2048" type="audio/mpeg"/>
              <itunes:duration>600</itunes:duration>
            </item>
          </channel>
        </rss>
        """
        .formatted(base, base, base);
  }

  @GetMapping(value = "/chapters.json", produces = MediaType.APPLICATION_JSON_VALUE)
  public String getChapters(HttpServletRequest request) {
    String base = getBaseUrl(request);
    return """
        {
          "version": "1.2.0",
          "chapters": [
            {
              "startTime": 0.0,
              "title": "Introduction",
              "img": "%s/mock/artwork.png",
              "toc": true,
              "endTime": 300.0
            },
            {
              "startTime": 300.0,
              "title": "Architecture Overview",
              "toc": true,
              "endTime": 900.0
            },
            {
              "startTime": 900.0,
              "title": "Conclusion",
              "toc": true,
              "endTime": 1800.0
            }
          ]
        }
        """
        .formatted(base);
  }

  @GetMapping(value = "/transcript.vtt", produces = "text/vtt")
  public String getVttTranscript() {
    return """
        WEBVTT

        00:00:00.000 --> 00:00:15.000
        <v Alice Smith> Welcome everyone to the Podku mock podcast episode one.

        00:00:15.500 --> 00:00:30.000
        <v Bob Jones> Thanks for having me Alice, happy to be here discussing audio streaming.

        00:00:30.500 --> 00:00:45.000
        <v Alice Smith> Let us dive into bookmarks and full-text search capabilities.
        """;
  }

  @GetMapping(value = "/transcript.srt", produces = "text/plain")
  public String getSrtTranscript() {
    return """
        1
        00:00:00,000 --> 00:00:15,000
        <v Alice Smith> Bienvenue au podcast Podku en francais.

        2
        00:00:15,500 --> 00:00:30,000
        <v Bob Jones> Merci Alice, ravi d'etre ici avec toi.
        """;
  }

  @GetMapping(value = "/audio.mp3", produces = "audio/mpeg")
  public ResponseEntity<byte[]> getAudio() {
    // Return 2048 bytes of mock audio
    byte[] audioData = new byte[2048];
    for (int i = 0; i < audioData.length; i++) {
      audioData[i] = (byte) (i % 128);
    }
    HttpHeaders headers = new HttpHeaders();
    headers.setContentLength(audioData.length);
    headers.set(HttpHeaders.ACCEPT_RANGES, "bytes");
    return ResponseEntity.ok().headers(headers).body(audioData);
  }

  @GetMapping(value = "/artwork.png", produces = MediaType.IMAGE_PNG_VALUE)
  public ResponseEntity<byte[]> getArtwork(
      @RequestHeader(value = HttpHeaders.IF_NONE_MATCH, required = false) String ifNoneMatch)
      throws IOException {
    if (ETAG_VALUE.equals(ifNoneMatch)) {
      return ResponseEntity.status(HttpStatus.NOT_MODIFIED).eTag(ETAG_VALUE).build();
    }

    BufferedImage img = new BufferedImage(32, 32, BufferedImage.TYPE_INT_RGB);
    Graphics2D g2d = img.createGraphics();
    g2d.setColor(new Color(66, 133, 244));
    g2d.fillRect(0, 0, 32, 32);
    g2d.dispose();

    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    ImageIO.write(img, "png", baos);
    byte[] bytes = baos.toByteArray();

    return ResponseEntity.ok()
        .eTag(ETAG_VALUE)
        .cacheControl(CacheControl.noCache())
        .contentType(MediaType.IMAGE_PNG)
        .body(bytes);
  }

  @GetMapping(value = "/podcast", produces = MediaType.TEXT_HTML_VALUE)
  public String getPodcastPage() {
    return "<html><body>Mock Podcast Home</body></html>";
  }
}
