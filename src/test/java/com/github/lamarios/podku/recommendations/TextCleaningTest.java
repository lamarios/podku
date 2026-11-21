package com.github.lamarios.podku.recommendations;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.search.SearchResult;
import java.util.List;
import java.util.stream.Stream;
import org.junit.jupiter.api.Test;

public class TextCleaningTest {

  @Test
  public void testRemovesAdParagraphsAndHtml() {
    String description =
        """
        <p>Linus and Luke discuss the new <b>AMD</b> GPUs.</p>
        <p>Thanks to Dell for sponsoring! Check out the XPS 14: https://del.ly/123</p>
        Get 20% off with promo code WAN
        Use code PODKU for a free trial<br>We review Kubernetes code quality tools
        """;

    assertEquals(
        "Linus and Luke discuss the new  AMD  GPUs.\nWe review Kubernetes code quality tools",
        RecommendationService.withoutAds(description));
  }

  @Test
  public void testNullDescription() {
    assertEquals("", RecommendationService.withoutAds(null));
  }

  @Test
  public void testDiversifyCapsKeywordSources() {
    List<RecommendationService.Scored> ranked =
        Stream.of("tesla", "tesla", "tesla", "", "", "", "nvidia")
            .map(
                source -> {
                  SearchResult result = new SearchResult();
                  result.setCollectionName(source + "-" + Math.random());
                  return new RecommendationService.Scored(
                      new RecommendationService.Candidate(result, source), 1);
                })
            .toList();

    List<String> sources =
        RecommendationService.diversify(ranked).stream()
            .map(r -> r.getCollectionName().split("-")[0])
            .toList();

    assertEquals(List.of("tesla", "tesla", "", "", "", "nvidia"), sources);
  }
}
