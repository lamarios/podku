package com.github.lamarios.podku.utils;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import java.util.List;
import java.util.Optional;

public interface OpenaiService {

  /**
   * Gets the topic about a timestamped bookmark.
   *
   * @param bookmarkedTranscript the transcript lined of the bookmark
   * @param surroundingTranscript transcript surrounding the bookmark so that the model can have
   *     more context
   * @return a String of the topic
   */
  Optional<BookmarkTopicResponse> getBookmarkTopic(
      EpisodeTranscript bookmarkedTranscript, List<EpisodeTranscript> surroundingTranscript);

  boolean enabled();
}
