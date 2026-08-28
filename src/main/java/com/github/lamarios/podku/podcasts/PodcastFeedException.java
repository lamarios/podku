/* (C)2026 */
package com.github.lamarios.podku.podcasts;

/** Checked-style runtime signal that a podcast feed could not be parsed or fetched. */
public class PodcastFeedException extends RuntimeException {
  /**
   * @param message description of the feed failure
   */
  public PodcastFeedException(String message) {
    super(message);
  }
}
