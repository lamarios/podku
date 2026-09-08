package com.github.lamarios.podku.search;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.podcasts.PodcastController;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

public class SearchControllerTest extends TestContainerTest {

  @Autowired private SearchController searchController;
  @Autowired private PodcastController podcastController;

  @MockitoBean private ItunesPodcastSearch itunesPodcastSearch;

  @Test
  public void testSearchFiltersSubscribedPodcasts() {
    String subscribedUrl = getBaseUrl() + "/mock/feed.xml";
    SearchResult subResult = new SearchResult();
    subResult.setFeedUrl(subscribedUrl);
    subResult.setCollectionName("Mock Tech Podcast");
    podcastController.subscribeToPodcast(subResult);

    SearchResult result1 = new SearchResult();
    result1.setFeedUrl(subscribedUrl);
    result1.setCollectionName("Mock Tech Podcast");

    SearchResult result2 = new SearchResult();
    result2.setFeedUrl("http://example.com/unsubscribed-podcast.xml");
    result2.setCollectionName("Unsubscribed Podcast");

    List<SearchResult> mockItunesResults = new ArrayList<>(List.of(result1, result2));
    when(itunesPodcastSearch.search("podcast", 10)).thenReturn(mockItunesResults);

    List<SearchResult> results = searchController.search("podcast", 10);
    assertEquals(1, results.size());
    assertEquals("Unsubscribed Podcast", results.get(0).getCollectionName());
    assertEquals("http://example.com/unsubscribed-podcast.xml", results.get(0).getFeedUrl());
  }
}
