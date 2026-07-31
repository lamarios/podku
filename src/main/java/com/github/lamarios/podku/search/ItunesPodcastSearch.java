package com.github.lamarios.podku.search;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * Thin client for the iTunes Search API, scoped to podcasts.
 */
@Component
public class ItunesPodcastSearch {

    private static final String SEARCH_URL = "https://itunes.apple.com/search";
    private static final String LOOKUP_URL = "https://itunes.apple.com/lookup";

    private final HttpClient client;
    private final ObjectMapper objectMapper;

    public ItunesPodcastSearch() {
        this(HttpClient.newHttpClient(), new ObjectMapper());
    }

    public ItunesPodcastSearch(HttpClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    /**
     * Searches the iTunes podcast directory.
     *
     * @param term    search string (name, author, etc.)
     * @param country ISO 2-letter country code, defaults to "US"
     * @param limit   max results, defaults to 25 (Apple's API default is 50)
     */
    public List<SearchResult> search(String term, String country, Integer limit) {
        String country_ = country != null ? country : "US";
        int limit_ = limit != null ? limit : 25;

        String query = "term=" + encode(term)
                + "&media=podcast"
                + "&entity=podcast"
                + "&country=" + encode(country_)
                + "&limit=" + limit_;

        JsonNode body = get(URI.create(SEARCH_URL + "?" + query), "iTunes search");

        List<SearchResult> results = new ArrayList<>();
        JsonNode resultsNode = body.get("results");
        if (resultsNode != null && resultsNode.isArray()) {
            for (JsonNode r : resultsNode) {
                results.add(objectMapper.convertValue(r, SearchResult.class));
            }
        }
        return results;
    }

    public List<SearchResult> search(String term) {
        return search(term, "US", 25);
    }

    /**
     * Looks up a single podcast by its iTunes collection ID.
     */
    public SearchResult lookupById(long collectionId) {
        String query = "id=" + collectionId + "&entity=podcast";
        JsonNode body = get(URI.create(LOOKUP_URL + "?" + query), "iTunes lookup");

        JsonNode resultsNode = body.get("results");
        if (resultsNode == null || !resultsNode.isArray() || resultsNode.isEmpty()) {
            return null;
        }
        return objectMapper.convertValue(resultsNode.get(0), SearchResult.class);
    }

    private JsonNode get(URI uri, String context) {
        try {
            HttpRequest request = HttpRequest.newBuilder(uri)
                    .GET()
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                throw new ItunesSearchException(
                        context + " failed with status " + response.statusCode());
            }
            return objectMapper.readTree(response.body());
        } catch (IOException e) {
            throw new ItunesSearchException(context + " failed: " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new ItunesSearchException(context + " interrupted");
        }
    }

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
