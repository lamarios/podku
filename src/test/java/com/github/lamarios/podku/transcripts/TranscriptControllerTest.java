package com.github.lamarios.podku.transcripts;

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

public class TranscriptControllerTest extends TestContainerTest {

  @Autowired private TranscriptController transcriptController;
  @Autowired private PodcastController podcastController;
  @Autowired private EpisodeController episodeController;

  private Episode episodeWithTranscripts;

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
    episodeWithTranscripts =
        episodes.stream()
            .filter(e -> e.getTitle().contains("Getting Started with Podku"))
            .findFirst()
            .orElseThrow();
  }

  @Test
  public void testGetEpisodeLanguages() {
    List<String> languages =
        transcriptController.getEpisodeLanguages(episodeWithTranscripts.getId().toString());
    assertNotNull(languages);
    assertFalse(languages.isEmpty());
    assertTrue(languages.contains("en"));
    assertTrue(languages.contains("fr"));
  }

  @Test
  public void testGetTranscriptVttAndSrt() {
    String episodeId = episodeWithTranscripts.getId().toString();

    // English transcript from VTT
    List<EpisodeTranscript> enTranscripts = transcriptController.getTranscript(episodeId, "en");
    assertNotNull(enTranscripts);
    assertFalse(enTranscripts.isEmpty());
    assertEquals(3, enTranscripts.size());

    EpisodeTranscript firstCue = enTranscripts.get(0);
    assertEquals("Alice Smith", firstCue.getSpeaker());
    assertTrue(firstCue.getContent().contains("Welcome everyone to the Podku mock podcast"));
    assertEquals("en", firstCue.getLanguage());

    // French transcript from SRT
    List<EpisodeTranscript> frTranscripts = transcriptController.getTranscript(episodeId, "fr");
    assertNotNull(frTranscripts);
    assertFalse(frTranscripts.isEmpty());
    assertEquals(2, frTranscripts.size());

    EpisodeTranscript frFirstCue = frTranscripts.get(0);
    assertEquals("Alice Smith", frFirstCue.getSpeaker());
    assertTrue(frFirstCue.getContent().contains("Bienvenue au podcast Podku en francais"));
    assertEquals("fr", frFirstCue.getLanguage());
  }

  @Test
  public void testGetTranscriptNonExistentLanguage() {
    String episodeId = episodeWithTranscripts.getId().toString();
    List<EpisodeTranscript> results = transcriptController.getTranscript(episodeId, "es");
    assertNotNull(results);
    assertTrue(results.isEmpty());
  }
}
