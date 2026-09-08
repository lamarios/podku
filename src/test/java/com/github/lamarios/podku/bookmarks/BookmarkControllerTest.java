package com.github.lamarios.podku.bookmarks;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeController;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastController;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.utils.BackgroundTasks;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

public class BookmarkControllerTest extends TestContainerTest {

  @Autowired private BookmarkController bookmarkController;
  @Autowired private PodcastController podcastController;
  @Autowired private EpisodeController episodeController;

  private Episode episode;

  @BeforeEach
  public void setUp() throws InterruptedException {
    SearchResult result = new SearchResult();
    result.setFeedUrl(getBaseUrl() + "/mock/feed.xml");
    result.setCollectionName("Mock Tech Podcast");
    result.setArtworkUrl(getBaseUrl() + "/mock/artwork.png");

    Podcast podcast = podcastController.subscribeToPodcast(result);
    assertNotNull(podcast);

    long timeout = System.currentTimeMillis() + 10000;
    while (BackgroundTasks.getInFlight().get() > 0 && System.currentTimeMillis() < timeout) {
      Thread.sleep(50);
    }

    List<Episode> episodes = episodeController.getEpisodes(null, 20);
    episode =
        episodes.stream()
            .filter(e -> e.getTitle().contains("Getting Started with Podku"))
            .findFirst()
            .orElseThrow();
  }

  @Test
  public void testSaveBookmarkAndGet() {
    Bookmark bookmark = new Bookmark();
    bookmark.setEpisode(episode);
    bookmark.setTime(10L);

    bookmarkController.saveBookmark(bookmark);

    List<BookmarkWithTranscript> list = bookmarkController.get();
    assertEquals(1, list.size());
    BookmarkWithTranscript bwt = list.get(0);
    assertEquals(10L, bwt.bookmark().getTime());
    assertEquals(episode.getId(), bwt.bookmark().getEpisode().getId());
    // In our mock transcript, cue 1 spans 00:00:00 to 00:00:15 (covers 10s)
    assertNotNull(bwt.transcripts());
    assertFalse(bwt.transcripts().isEmpty());
    assertTrue(bwt.transcripts().containsKey("en") || bwt.transcripts().containsKey("fr"));
  }

  @Test
  public void testDuplicateBookmarkPrevention() {
    Bookmark bm1 = new Bookmark();
    bm1.setEpisode(episode);
    bm1.setTime(10L);
    bookmarkController.saveBookmark(bm1);

    // Bookmark within 30-second window (e.g. 20s) should be skipped as duplicate
    Bookmark duplicate = new Bookmark();
    duplicate.setEpisode(episode);
    duplicate.setTime(20L);
    bookmarkController.saveBookmark(duplicate);

    List<BookmarkWithTranscript> list = bookmarkController.get();
    assertEquals(1, list.size());

    // Bookmark outside 30-second window (e.g. 60s) should be saved
    Bookmark nonDuplicate = new Bookmark();
    nonDuplicate.setEpisode(episode);
    nonDuplicate.setTime(60L);
    bookmarkController.saveBookmark(nonDuplicate);

    list = bookmarkController.get();
    assertEquals(2, list.size());
  }

  @Test
  public void testGetBookmarkByIdAndDelete() {
    Bookmark bookmark = new Bookmark();
    bookmark.setEpisode(episode);
    bookmark.setTime(15L);
    bookmarkController.saveBookmark(bookmark);

    List<BookmarkWithTranscript> list = bookmarkController.get();
    assertEquals(1, list.size());
    Bookmark savedBookmark = list.get(0).bookmark();
    String bookmarkId = savedBookmark.getId().toString();

    // Get by ID
    BookmarkWithTranscript fetched = bookmarkController.get(bookmarkId);
    assertNotNull(fetched);
    assertEquals(savedBookmark.getId(), fetched.bookmark().getId());
    assertEquals(15L, fetched.bookmark().getTime());

    // Delete bookmark
    bookmarkController.delete(bookmarkId);
    assertTrue(bookmarkController.get().isEmpty());
    assertNull(bookmarkController.get(bookmarkId));
  }
}
