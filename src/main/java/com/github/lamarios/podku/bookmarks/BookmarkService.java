package com.github.lamarios.podku.bookmarks;

import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import com.github.lamarios.podku.transcripts.EpisodeTranscriptRepository;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import org.apache.commons.lang3.time.DurationFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookmarkService {

  private final BookmarkRepository bookmarkRepository;
  private final EpisodeTranscriptRepository episodeTranscriptRepository;

  @Autowired
  public BookmarkService(
      BookmarkRepository bookmarkRepository,
      EpisodeTranscriptRepository episodeTranscriptRepository) {
    this.bookmarkRepository = bookmarkRepository;
    this.episodeTranscriptRepository = episodeTranscriptRepository;
  }

  @Transactional
  public void saveBookmark(Bookmark bookmark) {
    bookmarkRepository.save(bookmark);
  }

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

  @Transactional
  public void deleteBookmark(UUID uuid) {
    bookmarkRepository.deleteById(uuid);
  }
}
