/* (C)2026 */
package com.github.lamarios.podku.episodes;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

/** Spring Data JPA repository for {@link Chapter} entities. */
public interface ChapterRepository extends JpaRepository<Chapter, UUID> {
  /**
   * Removes every chapter that belongs to a given episode.
   *
   * @param episode the owning episode
   */
  void deleteChaptersByEpisode(Episode episode);
}
