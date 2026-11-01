/* (C)2026 */
package com.github.lamarios.podku.episodes;

public enum EpisodeFileType {
  transcript,
  chapters,
  audio,
  video;

  /**
   * Whether this file is a playable media (audio or video) rather than an episode resource that
   * needs processing (transcript, chapters).
   *
   * @return true for audio and video files
   */
  public boolean isMedia() {
    return this == audio || this == video;
  }
}
