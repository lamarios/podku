/* (C)2026 */
package com.github.lamarios.podku.recommendations;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.Instant;
import java.util.UUID;

/** Cached podcast recommendations of an episode. */
@Entity
@Table(name = "episode_recommendations")
public class EpisodeRecommendations {
  @Id
  @Column(name = "episode_id")
  private UUID episodeId;

  private Instant computedAt;

  /** JSON array of {@link com.github.lamarios.podku.search.SearchResult}, best match first. */
  private String results;

  /** Required by JPA. */
  protected EpisodeRecommendations() {}

  /**
   * Creates the cached recommendations of an episode.
   *
   * @param episodeId the episode the recommendations are for
   * @param computedAt when the recommendations were computed
   * @param results JSON array of search results, best match first
   */
  public EpisodeRecommendations(UUID episodeId, Instant computedAt, String results) {
    this.episodeId = episodeId;
    this.computedAt = computedAt;
    this.results = results;
  }

  /**
   * Gets the episode the recommendations are for.
   *
   * @return the episode id
   */
  public UUID getEpisodeId() {
    return episodeId;
  }

  /**
   * Gets when the recommendations were computed.
   *
   * @return the computation time
   */
  public Instant getComputedAt() {
    return computedAt;
  }

  /**
   * Gets the recommendations as a JSON array of search results, best match first.
   *
   * @return the JSON array
   */
  public String getResults() {
    return results;
  }
}
