package com.github.lamarios.podku.search;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.data.repository.query.Param;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/search")
@Tag(name = "Search")
public class SearchController {

    @GetMapping
    public List<SearchResult> search(@RequestParam("query") String query, @RequestParam("limit") int limit){
        return new ItunesPodcastSearch().search(query, limit);
    }
}
