package com.github.lamarios.podku.episodes;

import org.springframework.data.domain.Limit;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface EpisodeRepository extends JpaRepository<Episode, UUID> {
    List<Episode> findAllByProcessed(boolean processed);

    List<Episode> getEpisodeByPubDateMillisBefore(Long pubDateMillisBefore);

    List<Episode> getEpisodeByPubDateMillisBefore(Long pubDateMillisBefore, Sort sort, Limit limit);
}
