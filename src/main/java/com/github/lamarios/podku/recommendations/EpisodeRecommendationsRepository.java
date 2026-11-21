/* (C)2026 */
package com.github.lamarios.podku.recommendations;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * Spring Data JPA repository for {@link EpisodeRecommendations}, also holding the Postgres text
 * search queries used to compare texts.
 */
public interface EpisodeRecommendationsRepository
    extends JpaRepository<EpisodeRecommendations, UUID> {

  /** A distinctive word of a text. */
  interface Keyword {
    /**
     * The stemmed form of the word, as stored in tsvectors.
     *
     * @return the lexeme
     */
    String getLexeme();

    /**
     * The most common spelling of the word in the text, usable as a search term.
     *
     * @return the word
     */
    String getToken();

    /**
     * How distinctive the word is: its frequency in the text times its inverse document frequency
     * over the latest episodes of the library.
     *
     * @return the weight, always positive
     */
    double getWeight();
  }

  /** The number of occurrences of a word in a text. */
  interface LexemeCount {
    /**
     * The stemmed form of the word.
     *
     * @return the lexeme
     */
    String getLexeme();

    /**
     * The number of occurrences of the word.
     *
     * @return the count
     */
    int getCount();
  }

  /**
   * Finds the most distinctive words of a text using tf-idf, the frequencies being taken from the
   * 5000 latest episodes of the library.
   *
   * <p>The weight of a word is its log-scaled frequency in the text times two inverse frequencies:
   * over episodes, and over podcasts. The latter matters with small libraries, where common words
   * ("need", "came") are rare enough among episodes but used by every podcast.
   *
   * @param text the text to analyze
   * @param ignored space separated words that are never returned (podcast boilerplate)
   * @param limit maximum number of keywords to return
   * @return the keywords, most distinctive first
   */
  @Query(
      value =
          """
          WITH src AS (
              SELECT lower(d.token) AS token, d.lexemes[1] AS lexeme
              FROM ts_debug('english', :text) d
              WHERE d.alias IN ('asciiword', 'word') AND cardinality(d.lexemes) > 0
          ),
          ignored AS (
              SELECT unnest(tsvector_to_array(to_tsvector('english', :ignored))) AS lexeme
          ),
          tf AS (
              SELECT lexeme, count(*) AS tf, mode() WITHIN GROUP (ORDER BY token) AS token
              FROM src
              WHERE length(lexeme) > 2
                AND lexeme !~ '^[0-9]+$'
                AND lexeme NOT IN (SELECT lexeme FROM ignored)
              GROUP BY lexeme
          ),
          recent AS (
              SELECT podcast_id, search_vector
              FROM episodes
              ORDER BY pub_date_millis DESC NULLS LAST
              LIMIT 5000
          ),
          totals AS (
              SELECT count(*) AS episodes, count(DISTINCT podcast_id) AS podcasts FROM recent
          ),
          df AS (
              SELECT l.lexeme, count(*) AS episodes, count(DISTINCT r.podcast_id) AS podcasts
              FROM recent r
              CROSS JOIN LATERAL unnest(tsvector_to_array(r.search_vector)) l(lexeme)
              WHERE l.lexeme IN (SELECT lexeme FROM tf)
              GROUP BY l.lexeme
          )
          SELECT tf.lexeme AS lexeme,
                 tf.token AS token,
                 (1 + ln(tf.tf))
                     * ln((totals.episodes + 2.0) / (coalesce(df.episodes, 0) + 1.0))
                     * ln((totals.podcasts + 2.0) / (coalesce(df.podcasts, 0) + 0.5)) AS weight
          FROM tf
          CROSS JOIN totals
          LEFT JOIN df ON df.lexeme = tf.lexeme
          ORDER BY weight DESC, tf.tf DESC, tf.lexeme
          LIMIT :limit
          """,
      nativeQuery = true)
  List<Keyword> findKeywords(
      @Param("text") String text, @Param("ignored") String ignored, @Param("limit") int limit);

  /**
   * Counts the occurrences of every word of a text, stemmed and without stop words.
   *
   * @param text the text to analyze
   * @return the occurrences of each lexeme
   */
  @Query(
      value =
          """
          SELECT t.lexeme AS lexeme, coalesce(cardinality(t.positions), 1) AS count
          FROM unnest(to_tsvector('english', :text)) t
          """,
      nativeQuery = true)
  List<LexemeCount> countLexemes(@Param("text") String text);
}
