package com.github.lamarios.podku.podcasts;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.utils.BackgroundTasks;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

public class PodcastControllerTest extends TestContainerTest {

  @Autowired private PodcastController podcastController;

  private SearchResult createSearchResult(String feedUrl, String collectionName) {
    SearchResult result = new SearchResult();
    result.setFeedUrl(feedUrl);
    result.setCollectionName(collectionName);
    result.setArtworkUrl(getBaseUrl() + "/mock/artwork.png");
    return result;
  }

  private void waitForBackgroundTasks() throws InterruptedException {
    long timeout = System.currentTimeMillis() + 10000;
    while (BackgroundTasks.getInFlight().get() > 0 && System.currentTimeMillis() < timeout) {
      Thread.sleep(50);
    }
  }

  @Test
  public void testSubscribeAndGetPodcasts() {
    String feedUrl = getBaseUrl() + "/mock/feed.xml";
    SearchResult result = createSearchResult(feedUrl, "Mock Tech Podcast");

    Podcast podcast = podcastController.subscribeToPodcast(result);
    assertNotNull(podcast);
    assertNotNull(podcast.getId());
    assertEquals("Mock Tech Podcast", podcast.getName());
    assertEquals(feedUrl, podcast.getUrl());
    assertNotNull(podcast.getEpisodes());
    assertEquals(2, podcast.getEpisodes().size());

    // Duplicate subscription should return null
    Podcast duplicate = podcastController.subscribeToPodcast(result);
    assertNull(duplicate);

    // List podcasts
    List<PodcastLight> list = podcastController.getPodcasts();
    assertEquals(1, list.size());
    assertEquals("Mock Tech Podcast", list.get(0).getName());

    // Get single podcast by ID
    Podcast fetched = podcastController.getPodcast(podcast.getId().toString());
    assertNotNull(fetched);
    assertEquals(podcast.getId(), fetched.getId());
    assertEquals("Mock Tech Podcast", fetched.getName());
  }

  @Test
  public void testParsePodcastWithoutPersisting() {
    String feedUrl = getBaseUrl() + "/mock/feed.xml";
    SearchResult result = createSearchResult(feedUrl, "Mock Tech Podcast");

    Podcast parsed = podcastController.parsePodcast(result);
    assertNotNull(parsed);
    assertEquals("Mock Tech Podcast", parsed.getName());
    assertNotNull(parsed.getEpisodes());
    assertFalse(parsed.getEpisodes().isEmpty());

    // Verify it was NOT persisted
    List<PodcastLight> list = podcastController.getPodcasts();
    assertTrue(list.isEmpty());
  }

  @Test
  public void testSearchPodcasts() {
    String feedUrl = getBaseUrl() + "/mock/feed.xml";
    SearchResult result = createSearchResult(feedUrl, "Mock Tech Podcast");
    podcastController.subscribeToPodcast(result);

    // Postgres full-text search
    List<PodcastLight> searchResults = podcastController.search("Mock", 10);
    assertFalse(searchResults.isEmpty());
    assertEquals("Mock Tech Podcast", searchResults.get(0).getName());

    List<PodcastLight> emptyResults = podcastController.search("NonExistentQueryXYZ", 10);
    assertTrue(emptyResults.isEmpty());
  }

  @Test
  public void testExportAndImportFeeds() throws Exception {
    String feedUrl = getBaseUrl() + "/mock/feed.xml";
    SearchResult result = createSearchResult(feedUrl, "Mock Tech Podcast");
    Podcast subscribed = podcastController.subscribeToPodcast(result);
    assertNotNull(subscribed);

    // Export OPML
    var response = podcastController.exportFeeds();
    assertNotNull(response);
    StreamingResponseBody body = response.getBody();
    assertNotNull(body);

    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    body.writeTo(outputStream);
    String opmlContent = outputStream.toString(StandardCharsets.UTF_8);
    assertTrue(opmlContent.contains("Mock Tech Podcast") || opmlContent.contains(feedUrl));

    // Wait for any background processing of the initial feed to complete before unsubscribing
    waitForBackgroundTasks();

    // Delete existing podcast before importing
    podcastController.unsubsribe(subscribed.getId().toString());
    assertTrue(podcastController.getPodcasts().isEmpty());

    // Prepare OPML file for import with feed2
    String opmlToImport =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <opml version="2.0">
          <head>
            <title>Podku Test Export</title>
          </head>
          <body>
            <outline text="Second Mock Feed" title="Second Mock Feed" type="rss" xmlUrl="%s/mock/feed2.xml"/>
          </body>
        </opml>
        """
            .formatted(getBaseUrl());

    MockMultipartFile multipartFile =
        new MockMultipartFile(
            "file", "import.opml", "text/xml", opmlToImport.getBytes(StandardCharsets.UTF_8));

    List<PodcastLight> imported = podcastController.importFeed(multipartFile);
    assertFalse(imported.isEmpty());
    assertEquals("Second Mock Feed", imported.get(0).getName());

    waitForBackgroundTasks();
    List<PodcastLight> all = podcastController.getPodcasts();
    assertEquals(1, all.size());
  }

  @Test
  public void testUnsubscribe() throws Exception {
    String feedUrl = getBaseUrl() + "/mock/feed.xml";
    SearchResult result = createSearchResult(feedUrl, "Mock Tech Podcast");
    Podcast podcast = podcastController.subscribeToPodcast(result);
    assertNotNull(podcast);

    waitForBackgroundTasks();

    podcastController.unsubsribe(podcast.getId().toString());
    assertNull(podcastController.getPodcast(podcast.getId().toString()));
    assertTrue(podcastController.getPodcasts().isEmpty());
  }
}
