package com.github.lamarios.podku.bookmarks;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import com.github.lamarios.podku.transcripts.EpisodeTranscriptRepository;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import org.apache.commons.lang3.time.DurationFormatUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Business logic for bookmarks: persistence plus assembling bookmarks together with the transcript
 * segments that cover each bookmark's time position.
 */
@Service
public class BookmarkService {

  /** How close (in seconds) two bookmarks on the same episode may be before one is skipped. */
  private static final long DUPLICATE_WINDOW_SECONDS = 30;

  private final Logger log = LogManager.getLogger();
  private final BookmarkRepository bookmarkRepository;
  private final EpisodeTranscriptRepository episodeTranscriptRepository;

  /**
   * @param bookmarkRepository persistence for bookmarks
   * @param episodeTranscriptRepository persistence for episode transcripts
   */
  @Autowired
  public BookmarkService(
      BookmarkRepository bookmarkRepository,
      EpisodeTranscriptRepository episodeTranscriptRepository) {
    this.bookmarkRepository = bookmarkRepository;
    this.episodeTranscriptRepository = episodeTranscriptRepository;
  }

  /**
   * Persists a bookmark, unless the episode already has a bookmark within {@value
   * #DUPLICATE_WINDOW_SECONDS} seconds of its time; such near-duplicates are skipped.
   *
   * @param bookmark the bookmark to save
   */
  @Transactional
  public void saveBookmark(Bookmark bookmark) {
    long timeFrom = Math.max(0, bookmark.getTime() - DUPLICATE_WINDOW_SECONDS);
    long timeTo = bookmark.getTime() + DUPLICATE_WINDOW_SECONDS;
    boolean duplicate =
        bookmark.getId() != null
            ? bookmarkRepository.existsByEpisodeAndTimeBetweenAndIdNot(
                bookmark.getEpisode(), timeFrom, timeTo, bookmark.getId())
            : bookmarkRepository.existsByEpisodeAndTimeBetween(
                bookmark.getEpisode(), timeFrom, timeTo);
    if (duplicate) {
      log.info(
          "Skipping bookmark at {}s: an existing bookmark is within {}s of the same time",
          bookmark.getTime(),
          DUPLICATE_WINDOW_SECONDS);
      return;
    }
    bookmarkRepository.save(bookmark);
  }

  /**
   * Loads a single bookmark and pairs it with every transcript of its episode, grouped by language.
   *
   * @param id identifier of the bookmark
   * @return the bookmark with its transcripts, or {@code null} when no such bookmark exists
   */
  @Transactional(readOnly = true)
  public BookmarkWithTranscript getBookmark(UUID id) {
    var opt = bookmarkRepository.findById(id);
    if (opt.isPresent()) {
      var bookmark = opt.get();
      var transcripts =
          episodeTranscriptRepository
              .findAllByEpisode(bookmark.getEpisode(), Sort.by("startTime"))
              .stream()
              .collect(Collectors.groupingBy(EpisodeTranscript::getLanguage));
      return new BookmarkWithTranscript(bookmark, transcripts);

    } else {
      return null;
    }
  }

  /**
   * Loads all bookmarks, each paired with the transcript segments that cover its timestamp, grouped
   * by language.
   *
   * @return every bookmark enriched with its matching transcripts
   */
  @Transactional(readOnly = true)
  public List<BookmarkWithTranscript> getBookmarks() {
    List<Bookmark> bookmarks = bookmarkRepository.findAll();
    return bookmarks.stream()
        .map(
            bookmark -> {
              // we get the matching transcript for each bookmark
              String durationString =
                  DurationFormatUtils.formatDuration(
                      bookmark.getTime() * 1000L, "HH:mm:ss.SSS", true);
              var transcripts =
                  episodeTranscriptRepository
                      .findByStartTimeBeforeAndEndTimeAfterAndEpisode(
                          durationString, durationString, bookmark.getEpisode())
                      .stream()
                      .collect(Collectors.groupingBy(EpisodeTranscript::getLanguage));
              return new BookmarkWithTranscript(bookmark, transcripts);
            })
        .toList();
  }

  /**
   * Removes a bookmark by identifier.
   *
   * @param uuid identifier of the bookmark to delete
   */
  @Transactional
  public void deleteBookmark(UUID uuid) {
    bookmarkRepository.deleteById(uuid);
  }
}
