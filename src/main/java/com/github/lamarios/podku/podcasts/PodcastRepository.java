/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PodcastRepository extends JpaRepository<Podcast, UUID> {
    Optional<Podcast> findFirstByUrl(String url);

    void deletePodcastById(UUID id);

    @Query(value = """
        SELECT * FROM podcasts
        WHERE search_vector @@ to_tsquery('english', :query)
        ORDER BY ts_rank(search_vector, to_tsquery('english', :query)) DESC
        LIMIT :limit
        """, nativeQuery = true)
    List<Podcast> searchPodcasts(@Param("query") String query, @Param("limit") int limit);

    @Query("select p.id from Podcast p")
    List<UUID> findAllIds();
}
