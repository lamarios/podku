package com.github.lamarios.podku.episodes;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastController;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.utils.BackgroundTasks;
import com.github.lamarios.podku.websockets.PlaybackProgress;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

public class EpisodeControllerTest extends TestContainerTest {

  @Autowired private EpisodeController episodeController;
  @Autowired private PodcastController podcastController;

  private Podcast podcast;

  @BeforeEach
  public void setUp() throws InterruptedException {
    SearchResult result = new SearchResult();
    result.setFeedUrl(getBaseUrl() + "/mock/feed.xml");
    result.setCollectionName("Mock Tech Podcast");
    result.setArtworkUrl(getBaseUrl() + "/mock/artwork.png");

    podcast = podcastController.subscribeToPodcast(result);
    assertNotNull(podcast);

    long timeout = System.currentTimeMillis() + 10000;
    while (BackgroundTasks.getInFlight().get() > 0 && System.currentTimeMillis() < timeout) {
      Thread.sleep(50);
    }
  }

  @Test
  public void testGetEpisodes() {
    List<Episode> episodes = episodeController.getEpisodes(null, 20);
    assertFalse(episodes.isEmpty());
    assertEquals(2, episodes.size());

    // Newest first based on pubDateMillis
    assertTrue(episodes.get(0).getPubDateMillis() >= episodes.get(1).getPubDateMillis());

    // Test with pageSize 1
    List<Episode> paged = episodeController.getEpisodes(null, 1);
    assertEquals(1, paged.size());

    // Test with before timestamp
    long midpoint = episodes.get(0).getPubDateMillis();
    List<Episode> beforeMidpoint = episodeController.getEpisodes(midpoint, 20);
    assertEquals(1, beforeMidpoint.size());
    assertEquals(episodes.get(1).getId(), beforeMidpoint.get(0).getId());
  }

  @Test
  public void testGetEpisodeById() {
    List<Episode> episodes = episodeController.getEpisodes(null, 20);
    assertFalse(episodes.isEmpty());
    Episode first = episodes.get(0);

    Episode fetched = episodeController.getEpisode(first.getId().toString());
    assertNotNull(fetched);
    assertEquals(first.getId(), fetched.getId());
    assertEquals(first.getTitle(), fetched.getTitle());
    assertNotNull(fetched.getPodcast());
  }

  @Test
  public void testSetProgressAndBatch() {
    List<Episode> episodes = episodeController.getEpisodes(null, 20);
    assertFalse(episodes.isEmpty());
    Episode ep1 = episodes.get(0);
    Episode ep2 = episodes.get(1);

    // Test single progress update
    PlaybackProgress progress =
        new PlaybackProgress(ep1.getId().toString(), 123.45, "test-player", false);

    episodeController.setProgress(progress);

    Episode updatedEp1 = episodeController.getEpisode(ep1.getId().toString());
    assertEquals(123.45, updatedEp1.getProgress(), 0.001);

    // Test batch progress update
    OfflineProgress offline1 = new OfflineProgress();
    offline1.setProgress(200L);
    offline1.setTimeOfProgress(System.currentTimeMillis() + 1000);

    OfflineProgress offline2 = new OfflineProgress();
    offline2.setProgress(55L);
    offline2.setTimeOfProgress(System.currentTimeMillis() + 1000);

    boolean batchSuccess =
        episodeController.updateProgresses(
            Map.of(ep1.getId().toString(), offline1, ep2.getId().toString(), offline2));
    assertTrue(batchSuccess);

    assertEquals(200.0, episodeController.getEpisode(ep1.getId().toString()).getProgress(), 0.001);
    assertEquals(55.0, episodeController.getEpisode(ep2.getId().toString()).getProgress(), 0.001);
  }

  @Test
  public void testStartPlayback() {
    List<Episode> episodes = episodeController.getEpisodes(null, 20);
    assertFalse(episodes.isEmpty());

    PlaybackProgress progress =
        new PlaybackProgress(episodes.get(0).getId().toString(), 10.0, "test-player", true);

    assertDoesNotThrow(() -> episodeController.startPlayback(progress));
  }

  @Test
  public void testSearchEpisodes() {
    List<EpisodeSearchResult> results = episodeController.search("Podku", 10);
    assertFalse(results.isEmpty());
    assertTrue(results.get(0).episode().getTitle().contains("Getting Started with Podku"));

    List<EpisodeSearchResult> transcriptResults = episodeController.search("Transcripts", 10);
    assertFalse(transcriptResults.isEmpty());

    List<EpisodeSearchResult> empty = episodeController.search("RandomUnknownTermXYZ", 10);
    assertTrue(empty.isEmpty());
  }
}
