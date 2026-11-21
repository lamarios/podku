/* (C)2026 */
package com.github.lamarios.podku.recommendations;

import com.github.lamarios.podku.search.SearchResult;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** REST API for podcast recommendations. */
@RestController
@RequestMapping("/api/episodes")
@Tag(name = "Recommendations")
public class RecommendationController {
  private final RecommendationService recommendationService;

  /**
   * Constructs the RecommendationController.
   *
   * @param recommendationService computes and caches the recommendations
   */
  public RecommendationController(RecommendationService recommendationService) {
    this.recommendationService = recommendationService;
  }

  /**
   * Recommends podcasts related to an episode, excluding subscribed podcasts. The first call for an
   * episode can take several seconds, results are then cached for a week.
   *
   * @param episodeId the episode
   * @param limit maximum number of podcasts to return (default 6)
   * @return the recommended podcasts, best match first, ready to be subscribed to
   */
  @GetMapping("{episodeId}/recommendations")
  public List<SearchResult> getEpisodeRecommendations(
      @PathVariable UUID episodeId,
      @RequestParam(required = false, defaultValue = "6") Integer limit) {
    return recommendationService.getRecommendations(episodeId, limit);
  }
}
