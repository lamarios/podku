package com.github.lamarios.podku.podcasts;

import static com.github.lamarios.podku.mock.MockFeeds.feed;
import static com.github.lamarios.podku.mock.MockFeeds.item;
import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeFile;
import com.github.lamarios.podku.episodes.EpisodeFileType;
import com.github.lamarios.podku.mock.MockFeedController;
import com.github.lamarios.podku.mock.MockFeedController.DynamicResponse;
import com.github.lamarios.podku.utils.FastUrlCrypto;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;

public class PodcastParserTest extends TestContainerTest {
  @Autowired private PodcastParser parser;

  private Podcast podcastAt(String path) {
    Podcast podcast = new Podcast();
    podcast.setUrl(getBaseUrl() + path);
    return podcast;
  }

  private DynamicResponse xml(String body, String etag, String lastModified) {
    return new DynamicResponse(200, MediaType.APPLICATION_XML_VALUE, body, etag, lastModified);
  }

  @Test
  public void testParsesFeed() throws Exception {
    MockFeedController.serve(
        "feed",
        feed(
            "Parser test",
            item("a", "Episode A").transcript("http://localhost/a.vtt", "en"),
            item("b", "Episode B")));

    Podcast podcast = parser.parseUrl(podcastAt("/mock/dynamic/feed"));

    assertEquals("Parser test", podcast.getName());
    assertEquals(
        List.of("Episode A", "Episode B"),
        podcast.getEpisodes().stream().map(Episode::getTitle).toList());
    Episode a = podcast.getEpisodes().getFirst();
    assertSame(podcast, a.getPodcast());
    assertEquals(
        List.of(EpisodeFileType.transcript, EpisodeFileType.audio),
        a.getFiles().stream().map(EpisodeFile::getType).toList());
    assertTrue(a.getFiles().stream().allMatch(f -> f.getEpisode() == a));
    EpisodeFile audio = a.getFiles().getLast();
    assertEquals("http://localhost/EpisodeA.mp3", audio.getUrl());
    assertEquals("audio/mpeg", audio.getMime());
    assertEquals(1L, audio.getLengthBytes());
    assertTrue(audio.getDefaultMedia());
    assertEquals(audio.getUrl(), FastUrlCrypto.instance.decrypt(audio.getUrlEncrypted()));
  }

  @Test
  public void testParsesAlternateEnclosures() {
    MockFeedController.serve(
        "feed",
        feed(
            "Media",
            item("a", "a")
                .alternateEnclosure(
                    "video/mp4", 1080, "HD", "http://localhost/a-1080.mp4", "ipfs://a-1080")
                .alternateEnclosure(
                    "application/x-mpegURL", 720, "Stream", "http://localhost/a.m3u8")
                .alternateEnclosure("audio/opus", null, "Opus", "http://localhost/a.opus")
                // repeats the main enclosure, kept once
                .alternateEnclosure("audio/mpeg", null, "Default", "http://localhost/a.mp3")));

    List<EpisodeFile> files =
        parser.parseUrl(podcastAt("/mock/dynamic/feed")).getEpisodes().getFirst().getFiles();

    assertEquals(
        List.of(
            "http://localhost/a.mp3",
            "http://localhost/a-1080.mp4",
            "ipfs://a-1080",
            "http://localhost/a.m3u8",
            "http://localhost/a.opus"),
        files.stream().map(EpisodeFile::getUrl).toList());
    assertEquals(
        List.of(
            EpisodeFileType.audio,
            EpisodeFileType.video,
            EpisodeFileType.video,
            EpisodeFileType.video,
            EpisodeFileType.audio),
        files.stream().map(EpisodeFile::getType).toList());
    EpisodeFile hd = files.get(1);
    assertEquals("video/mp4", hd.getMime());
    assertEquals(1080, hd.getHeight());
    assertEquals("HD", hd.getTitle());
    assertEquals(42L, hd.getLengthBytes());
    assertEquals(128.5, hd.getBitrate());
    assertFalse(hd.getDefaultMedia());
  }

  @Test
  public void testDuplicateItemsAreKeptOnce() {
    MockFeedController.serve(
        "feed",
        feed(
            "Duplicates",
            item("a", "First A"),
            item("a", "Second A"),
            item("b", "B"),
            item(null, "No guid").audio("http://localhost/same.mp3"),
            item(null, "No guid again").audio("http://localhost/same.mp3")));

    Podcast podcast = parser.parseUrl(podcastAt("/mock/dynamic/feed"));

    // the first occurrence wins
    assertEquals(
        List.of("First A", "B", "No guid"),
        podcast.getEpisodes().stream().map(Episode::getTitle).toList());
  }

  @Test
  public void testParsesItemsWithoutGuid() {
    MockFeedController.serve("feed", feed("No guids", item(null, "A"), item(null, "B")));

    Podcast podcast = parser.parseUrl(podcastAt("/mock/dynamic/feed"));

    assertEquals(2, podcast.getEpisodes().size());
    assertTrue(podcast.getEpisodes().stream().allMatch(e -> e.getGuid() == null));
  }

  @Test
  public void testKeepsGivenArtworkWhenFeedHasNone() {
    MockFeedController.serve("feed", feed("No artwork", item("a", "A")));
    Podcast podcast = podcastAt("/mock/dynamic/feed");
    podcast.setArtworkUrl(getBaseUrl() + "/mock/artwork.png");

    Podcast parsed = parser.parseUrl(podcast);

    assertEquals(getBaseUrl() + "/mock/artwork.png", parsed.getArtworkUrl());
    assertNotNull(parsed.getColor(), "color is extracted from the artwork");
  }

  @Test
  public void testStoresCacheHeaders() {
    MockFeedController.serve(
        "feed", xml(feed("Cached", item("a", "A")), "\"v1\"", "Mon, 01 Jan 2024 12:00:00 GMT"));

    Podcast podcast = parser.parseUrl(podcastAt("/mock/dynamic/feed"));

    assertEquals("\"v1\"", podcast.getEtag());
    assertEquals("Mon, 01 Jan 2024 12:00:00 GMT", podcast.getLastModified());
  }

  @Test
  public void testNoCacheHeadersWhenServerSendsNone() {
    MockFeedController.serve("feed", feed("Not cached", item("a", "A")));

    Podcast podcast = parser.parseUrl(podcastAt("/mock/dynamic/feed"));

    assertNull(podcast.getEtag());
    assertNull(podcast.getLastModified());
  }

  @Test
  public void testConditionalFetchWithEtag() {
    MockFeedController.serve("feed", xml(feed("Etag", item("a", "A")), "\"v1\"", null));

    assertTrue(
        parser.parseUrlIfModified(podcastAt("/mock/dynamic/feed"), "\"v1\"", null).isEmpty(),
        "matching etag gives a 304");
    Optional<Podcast> changed =
        parser.parseUrlIfModified(podcastAt("/mock/dynamic/feed"), "\"v0\"", null);
    assertTrue(changed.isPresent(), "different etag gives the feed");
    assertEquals("\"v1\"", changed.get().getEtag());
    assertEquals(1, MockFeedController.fullResponses("feed"));
  }

  @Test
  public void testConditionalFetchWithLastModified() {
    String date = "Mon, 01 Jan 2024 12:00:00 GMT";
    MockFeedController.serve("feed", xml(feed("Last modified", item("a", "A")), null, date));

    assertTrue(
        parser.parseUrlIfModified(podcastAt("/mock/dynamic/feed"), null, date).isEmpty(),
        "matching date gives a 304");
    assertTrue(
        parser
            .parseUrlIfModified(
                podcastAt("/mock/dynamic/feed"), null, "Sun, 31 Dec 2023 12:00:00 GMT")
            .isPresent());
  }

  @Test
  public void testFollowsRedirects() {
    MockFeedController.serve("moved", feed("Moved feed", item("a", "A")));

    Podcast podcast = parser.parseUrl(podcastAt("/mock/redirect/moved"));

    assertEquals("Moved feed", podcast.getName());
    assertEquals(1, podcast.getEpisodes().size());
  }

  @Test
  public void testErrorStatusThrows() {
    Podcast missing = podcastAt("/mock/dynamic/does-not-exist");
    var e = assertThrows(PodcastFeedException.class, () -> parser.parseUrl(missing));
    assertTrue(e.getMessage().contains("404"));
  }

  @Test
  public void testUnreachableHostThrows() {
    Podcast unreachable = new Podcast();
    unreachable.setUrl("http://localhost:1/feed.xml");
    assertThrows(PodcastFeedException.class, () -> parser.parseUrl(unreachable));
  }
}
