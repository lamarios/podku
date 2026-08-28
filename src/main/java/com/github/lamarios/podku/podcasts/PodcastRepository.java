/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * Spring Data JPA repository for {@link Podcast} entities, including full-text search backed by a
 * Postgres {@code search_vector} column.
 */
public interface PodcastRepository extends JpaRepository<Podcast, UUID> {
  /**
   * Derived query: finds the first subscription matching an exact feed URL.
   *
   * @param url the podcast feed URL to look up
   * @return the matching podcast, or empty when none exists
   */
  Optional<Podcast> findFirstByUrl(String url);

  /**
   * Derived query: deletes the podcast with the given identifier.
   *
   * @param id identifier of the podcast to delete
   */
  void deletePodcastById(UUID id);

  /**
   * Full-text search over podcasts, ranked by {@code ts_rank} against the {@code search_vector}.
   *
   * @param query English tsquery (tokenized free-text) to match
   * @param limit maximum number of podcasts to return
   * @return matching podcasts ordered by relevance
   */
  @Query(
      value =
          """
        SELECT * FROM podcasts
        WHERE search_vector @@ to_tsquery('english', :query)
        ORDER BY ts_rank(search_vector, to_tsquery('english', :query)) DESC
        LIMIT :limit
        """,
      nativeQuery = true)
  List<Podcast> searchPodcasts(@Param("query") String query, @Param("limit") int limit);

  /**
   * Returns the identifiers of every stored podcast.
   *
   * @return all podcast ids
   */
  @Query("select p.id from Podcast p")
  List<UUID> findAllIds();
}
