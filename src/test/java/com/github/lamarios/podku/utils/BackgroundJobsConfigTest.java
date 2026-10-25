package com.github.lamarios.podku.utils;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

/** Tests the configuration and helpers used by the scheduled background jobs. */
public class BackgroundJobsConfigTest extends TestContainerTest {
  @Autowired private ThreadPoolTaskScheduler taskScheduler;

  @Test
  public void testSchedulerHasASpareThread() {
    // the hourly refresh must not block the websocket ping / cleanup jobs
    assertEquals(2, taskScheduler.getScheduledThreadPoolExecutor().getCorePoolSize());
  }

  @Test
  public void testColorIsExtractedFromArtwork() throws Exception {
    String color = VibrantColorExtractor.extractVibrantColorHex(getBaseUrl() + "/mock/artwork.png");

    assertNotNull(color);
    assertTrue(color.matches("#[0-9A-F]{6}"), color);
  }

  @Test
  public void testColorExtractionFailsOnUnreachableArtwork() {
    assertThrows(
        Exception.class,
        () -> VibrantColorExtractor.extractVibrantColorHex("http://localhost:1/artwork.png"));
  }
}
