package com.github.lamarios.podku.episodes;

import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

public class EpisodeUtilsTest {

  private Episode episode(String guid, String audioUrl, String title) {
    Episode episode = new Episode();
    episode.setGuid(guid);
    episode.setTitle(title);
    episode.setFiles(new ArrayList<>());
    if (audioUrl != null) {
      episode.getFiles().add(file(EpisodeFileType.audio, audioUrl, true));
    }
    return episode;
  }

  private EpisodeFile file(EpisodeFileType type, String url, Boolean defaultMedia) {
    EpisodeFile file = new EpisodeFile();
    file.setType(type);
    file.setUrl(url);
    file.setDefaultMedia(defaultMedia);
    return file;
  }

  @Test
  public void testDefaultMediaPrefersDefaultFlag() {
    Episode episode = episode("a", null, "A");
    episode
        .getFiles()
        .addAll(
            List.of(
                file(EpisodeFileType.transcript, "http://localhost/a.vtt", null),
                file(EpisodeFileType.video, "http://localhost/a.mp4", false),
                file(EpisodeFileType.audio, "http://localhost/a.mp3", true)));

    assertEquals("http://localhost/a.mp3", EpisodeUtils.defaultMediaUrl(episode));
  }

  @Test
  public void testDefaultMediaFallsBackToFirstMedia() {
    Episode episode = episode("a", null, "A");
    episode
        .getFiles()
        .addAll(
            List.of(
                file(EpisodeFileType.chapters, "http://localhost/a.json", null),
                file(EpisodeFileType.video, "http://localhost/a.mp4", false),
                file(EpisodeFileType.audio, "http://localhost/a.mp3", false)));

    assertEquals("http://localhost/a.mp4", EpisodeUtils.defaultMediaUrl(episode));
  }

  @Test
  public void testNoDefaultMediaWithoutMediaFiles() {
    Episode episode = episode("a", null, "A");
    episode.getFiles().add(file(EpisodeFileType.transcript, "http://localhost/a.vtt", null));

    assertNull(EpisodeUtils.defaultMedia(episode));
    episode.setFiles(null);
    assertNull(EpisodeUtils.defaultMedia(episode));
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
