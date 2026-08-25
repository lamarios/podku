package com.github.lamarios.podku.bookmarks;

import com.github.lamarios.podku.episodes.Episode;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

/** Spring Data JPA repository for {@link Bookmark} entities. */
public interface BookmarkRepository extends JpaRepository<Bookmark, UUID> {

  /**
   * Checks whether the episode already has a bookmark whose time falls within the given inclusive
   * range.
   *
   * @param episode the episode to search in
   * @param timeFrom lower bound of the time range, in seconds
   * @param timeTo upper bound of the time range, in seconds
   * @return {@code true} when such a bookmark exists
   */
  boolean existsByEpisodeAndTimeBetween(Episode episode, long timeFrom, long timeTo);

  /**
   * Checks whether the episode already has a bookmark (other than the one with the given
   * identifier) whose time falls within the given inclusive range.
   *
   * @param episode the episode to search in
   * @param timeFrom lower bound of the time range, in seconds
   * @param timeTo upper bound of the time range, in seconds
   * @param id identifier of the bookmark to exclude from the check
   * @return {@code true} when such a bookmark exists
   */
  boolean existsByEpisodeAndTimeBetweenAndIdNot(
      Episode episode, long timeFrom, long timeTo, UUID id);
}
