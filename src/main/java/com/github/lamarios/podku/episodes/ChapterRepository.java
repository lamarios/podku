package com.github.lamarios.podku.episodes;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ChapterRepository extends JpaRepository<Chapter, UUID> {
    void deleteChaptersByEpisode(Episode episode);
}
