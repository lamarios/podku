package com.github.lamarios.podku.episodes;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

public class EpisodeUtilsTest {

  private Episode episode(String guid, String audioUrl, String title) {
    Episode episode = new Episode();
    episode.setGuid(guid);
    episode.setAudioUrl(audioUrl);
    episode.setTitle(title);
    return episode;
  }

  @Test
  public void testIdentityKeyPrefersGuid() {
    assertEquals(
        "guid:abc", EpisodeUtils.identityKey(episode("abc", "http://localhost/a.mp3", "A")));
  }

  @Test
  public void testIdentityKeyFallsBackToAudioUrl() {
    assertEquals(
        "audio:http://localhost/a.mp3",
        EpisodeUtils.identityKey(episode(null, "http://localhost/a.mp3", "A")));
    assertEquals(
        "audio:http://localhost/a.mp3",
        EpisodeUtils.identityKey(episode("  ", "http://localhost/a.mp3", "A")));
  }

  @Test
  public void testIdentityKeyFallsBackToTitle() {
    assertEquals("title:A", EpisodeUtils.identityKey(episode(null, null, "A")));
    assertEquals("title:A", EpisodeUtils.identityKey(episode("", "", "A")));
  }

  @Test
  public void testIdentityKeysDoNotCollideAcrossKinds() {
    // a guid that looks like a URL must not match an episode identified by that audio URL
    assertNotEquals(
        EpisodeUtils.identityKey(episode("http://localhost/a.mp3", null, "A")),
        EpisodeUtils.identityKey(episode(null, "http://localhost/a.mp3", "A")));
  }
}
