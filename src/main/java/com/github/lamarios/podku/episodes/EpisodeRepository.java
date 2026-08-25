/* (C)2026 */
package com.github.lamarios.podku.episodes;

import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * Spring Data JPA repository for {@link Episode} entities, including full-text search backed by
 * Postgres {@code tsvector} columns.
 */
public interface EpisodeRepository extends JpaRepository<Episode, UUID> {
  /**
   * Derived query: episodes whose publish date is older than a given instant.
   *
   * @param pubDateMillisBefore upper bound (epoch millis) on the episode publish date
   * @param sort ordering to apply (typically publish date descending)
   * @param limit maximum number of rows to return
   * @return matching episodes
   */
  List<Episode> getEpisodeByPubDateMillisBefore(Long pubDateMillisBefore, Sort sort, Limit limit);

  /**
   * Full-text search over episode metadata and their transcripts, ranked by the best ts_rank
   * between the two search vectors.
   *
   * @param query English tsquery (tokenized free-text) to match against
   * @param limit maximum number of episodes to return
   * @return matching episodes ordered by relevance
   */
  @Query(
      value =
          """
            SELECT e.*
            FROM episodes e
            LEFT JOIN episode_transcripts et ON et.episode_id = e.id
            WHERE e.search_vector @@ TO_TSQUERY('english', :query)
               OR et.search_vector @@ TO_TSQUERY('english', :query)
            GROUP BY e.id
            ORDER BY GREATEST(
                TS_RANK(e.search_vector, TO_TSQUERY('english', :query)),
                COALESCE(MAX(TS_RANK(et.search_vector, TO_TSQUERY('english', :query))), 0)
            ) DESC
            LIMIT :limit
            """,
      nativeQuery = true)
  List<Episode> search(@Param("query") String query, @Param("limit") int limit);

  /**
   * Streams all episodes with a given processing flag, suitable for bulk operations without loading
   * everything into memory.
   *
   * @param processed whether the episode has already been processed (transcription etc.)
   * @return matching episodes
   */
  List<Episode> streamAllByProcessed(boolean processed);
}
