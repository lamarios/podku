/* (C)2026 */
package com.github.lamarios.podku.search;

import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastService;
import io.swagger.v3.oas.annotations.tags.Tag;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/search")
@Tag(name = "Search")
public class SearchController {
    private final PodcastService podcastService;
    private final ItunesPodcastSearch itunesPodcastSearch;

    @Autowired
    public SearchController(PodcastService podcastService, ItunesPodcastSearch itunesPodcastSearch) {
        this.podcastService = podcastService;
        this.itunesPodcastSearch = itunesPodcastSearch;
    }

    @GetMapping
    public List<SearchResult> search(@RequestParam("query") String query, @RequestParam("limit") int limit) {
        var subscribedPodcasts = podcastService.getPodcasts().stream().map(Podcast::getUrl).toList();

        List<SearchResult> results = itunesPodcastSearch.search(query, limit);
        results.removeIf(result -> subscribedPodcasts.contains(result.getFeedUrl()));
        return results;
    }
}
