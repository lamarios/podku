package com.github.lamarios.podku.podcasts;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface PodcastRepository extends JpaRepository<Podcast, UUID> {
    Optional<Podcast> findFirstByUrl(String url);

    long countPodcastsByUrl(String url);

    void deletePodcastById(UUID id);
}
