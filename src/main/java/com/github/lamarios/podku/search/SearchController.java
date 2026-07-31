package com.github.lamarios.podku.search;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/search")
@Tag(name = "Search")
public class SearchController {

    @PostMapping
    public List<SearchResult> search(@RequestBody String query){
        return new ItunesPodcastSearch().search(query);
    }
}
