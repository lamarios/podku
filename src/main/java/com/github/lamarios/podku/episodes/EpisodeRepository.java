/* (C)2026 */
package com.github.lamarios.podku.episodes;

import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface EpisodeRepository extends JpaRepository<Episode, UUID> {
    List<Episode> getEpisodeByPubDateMillisBefore(Long pubDateMillisBefore, Sort sort, Limit limit);

    @Query(value = """
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
            """, nativeQuery = true)
    List<Episode> search(@Param("query") String query, @Param("limit") int limit);

    List<Episode> streamAllByProcessed(boolean processed);
}
