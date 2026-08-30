/* (C)2026 */
package com.github.lamarios.podku.transcripts;

import com.github.lamarios.podku.episodes.Episode;
import jakarta.persistence.Tuple;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface EpisodeTranscriptRepository extends JpaRepository<EpisodeTranscript, UUID> {
  Object findFirstByEpisodeEqualsAndLanguage(Episode episode, String language);

  @Query("select distinct t.language from EpisodeTranscript t where t.episode = :episode")
  List<String> findDistinctLanguagesForEpisode(Episode episode);

  List<EpisodeTranscript> findAllByEpisode(Episode episode, Sort sort);

  List<EpisodeTranscript> findAllByEpisodeAndLanguage(Episode episode, String language, Sort sort);

  @Query(
      value =
          """
            SELECT et.*,
            TS_HEADLINE(
                'english',
                et.content,
                TO_TSQUERY('english', :query),
                'StartSel=§, StopSel=§, HighlightAll=true'
            ) AS highlighted_content
            FROM  episode_transcripts et
            WHERE  et.search_vector @@ TO_TSQUERY('english', :query)
            AND et.episode_id = ANY(:episodes)
            """,
      nativeQuery = true)
  List<Tuple> search(@Param("query") String query, @Param("episodes") UUID[] episodeIds);

  List<EpisodeTranscript> findAllByEpisodeIn(Collection<Episode> episodes);

  List<EpisodeTranscript> findByStartTimeBeforeAndEndTimeAfterAndEpisode(
      String startTimeBefore, String endTimeAfter, Episode episode);

  List<EpisodeTranscript> findAllByEpisodeAndLanguageAndStartTimeGreaterThanAndEndTimeLessThanEqual(
      Episode episode, String language, String startTimeIsGreaterThan, String endTimeIsLessThan);
}
