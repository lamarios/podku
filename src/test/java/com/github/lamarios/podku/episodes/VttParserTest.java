package com.github.lamarios.podku.episodes;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import java.util.List;
import org.junit.jupiter.api.Test;

public class VttParserTest {

  private final VttParser parser = new VttParser();

  @Test
  public void testParseStandardVtt() {
    String vtt =
        """
        WEBVTT - Podcast Transcript

        00:00:01.000 --> 00:00:05.500
        <v Alice>Hello and welcome to the show!

        00:00:06.000 --> 00:00:10.250
        <v Bob>Thanks Alice! Glad to be here.
        Today we talk about tests.

        00:00:11.000 --> 00:00:15.000
        This cue has no speaker tag.
        """;

    Episode episode = new Episode();
    episode.setTitle("Test Episode");

    List<EpisodeTranscript> cues = parser.parse(vtt, episode, "en");
    assertNotNull(cues);
    assertEquals(3, cues.size());

    // Cue 1
    EpisodeTranscript c1 = cues.get(0);
    assertEquals("00:00:01.000", c1.getStartTime());
    assertEquals("00:00:05.500", c1.getEndTime());
    assertEquals("Alice", c1.getSpeaker());
    assertEquals("Hello and welcome to the show!", c1.getContent());
    assertEquals("en", c1.getLanguage());
    assertSame(episode, c1.getEpisode());

    // Cue 2 (multiline)
    EpisodeTranscript c2 = cues.get(1);
    assertEquals("00:00:06.000", c2.getStartTime());
    assertEquals("00:00:10.250", c2.getEndTime());
    assertEquals("Bob", c2.getSpeaker());
    assertEquals("Thanks Alice! Glad to be here.\nToday we talk about tests.", c2.getContent());

    // Cue 3 (no speaker)
    EpisodeTranscript c3 = cues.get(2);
    assertEquals("00:00:11.000", c3.getStartTime());
    assertEquals("00:00:15.000", c3.getEndTime());
    assertNull(c3.getSpeaker());
    assertEquals("This cue has no speaker tag.", c3.getContent());
  }

  @Test
  public void testParseShortTimestamps() {
    String vtt =
        """
        WEBVTT

        01:15.000 --> 01:20.500
        Short timestamp cue text
        """;

    Episode episode = new Episode();
    List<EpisodeTranscript> cues = parser.parse(vtt, episode, "en");
    assertEquals(1, cues.size());
    assertEquals("01:15.000", cues.get(0).getStartTime());
    assertEquals("01:20.500", cues.get(0).getEndTime());
    assertEquals("Short timestamp cue text", cues.get(0).getContent());
  }

  @Test
  public void testParseEmptyOrMalformed() {
    Episode episode = new Episode();
    List<EpisodeTranscript> cues = parser.parse("WEBVTT\n\nNot a timestamp line", episode, "en");
    assertTrue(cues.isEmpty());

    List<EpisodeTranscript> empty = parser.parse("", episode, "en");
    assertTrue(empty.isEmpty());
  }
}
