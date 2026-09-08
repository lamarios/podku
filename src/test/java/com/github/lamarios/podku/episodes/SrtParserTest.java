package com.github.lamarios.podku.episodes;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import java.util.List;
import org.junit.jupiter.api.Test;

public class SrtParserTest {

  private final SrtParser parser = new SrtParser();

  @Test
  public void testParseStandardSrt() {
    String srt =
        """
        1
        00:00:01,000 --> 00:00:04,500
        <v Alice>Welcome to the show!

        2
        00:00:05,000 --> 00:00:09,200
        <v Bob>Hello everyone.
        Welcome back.

        3
        00:00:10,000 --> 00:00:14,000
        Speakerless SRT line.
        """;

    Episode episode = new Episode();
    List<EpisodeTranscript> cues = parser.parse(srt, episode, "en");

    assertNotNull(cues);
    assertEquals(3, cues.size());

    // Cue 1
    EpisodeTranscript c1 = cues.get(0);
    assertEquals("00:00:01,000", c1.getStartTime());
    assertEquals("00:00:04,500", c1.getEndTime());
    assertEquals("Alice", c1.getSpeaker());
    assertEquals("Welcome to the show!", c1.getContent());
    assertEquals("en", c1.getLanguage());

    // Cue 2 (multiline)
    EpisodeTranscript c2 = cues.get(1);
    assertEquals("00:00:05,000", c2.getStartTime());
    assertEquals("00:00:09,200", c2.getEndTime());
    assertEquals("Bob", c2.getSpeaker());
    assertEquals("Hello everyone.\nWelcome back.", c2.getContent());

    // Cue 3 (no speaker)
    EpisodeTranscript c3 = cues.get(2);
    assertEquals("00:00:10,000", c3.getStartTime());
    assertEquals("00:00:14,000", c3.getEndTime());
    assertNull(c3.getSpeaker());
    assertEquals("Speakerless SRT line.", c3.getContent());
  }

  @Test
  public void testParseMalformedLinesSkipped() {
    String srt =
        """
        1
        Invalid timestamp line
        Some text

        2
        00:01:00,000 --> 00:01:05,000
        Valid cue
        """;

    Episode episode = new Episode();
    List<EpisodeTranscript> cues = parser.parse(srt, episode, "en");
    assertEquals(1, cues.size());
    assertEquals("Valid cue", cues.get(0).getContent());
  }
}
