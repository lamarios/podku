/* (C)2026 */
package com.github.lamarios.podku.episodes;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ChapterRepository extends JpaRepository<Chapter, UUID> {
  void deleteChaptersByEpisode(Episode episode);
}
