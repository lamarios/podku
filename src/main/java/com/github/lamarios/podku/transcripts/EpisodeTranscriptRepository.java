/* (C)2026 */
package com.github.lamarios.podku.transcripts;

import com.github.lamarios.podku.episodes.Episode;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface EpisodeTranscriptRepository extends JpaRepository<EpisodeTranscript, UUID> {
    Object findFirstByEpisodeEqualsAndLanguage(Episode episode, String language);

    @Query("select distinct t.language from EpisodeTranscript t where t.episode = :episode")
    List<String> findDistinctLanguagesForEpisode(Episode episode);

    List<EpisodeTranscript> findAllByEpisode(Episode episode, Sort sort);

    List<EpisodeTranscript> findAllByEpisodeAndLanguage(Episode episode, String language, Sort sort);
}
