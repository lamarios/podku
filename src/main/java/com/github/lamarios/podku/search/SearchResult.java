/* (C)2026 */
package com.github.lamarios.podku.search;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.lamarios.podku.utils.FastUrlCrypto;
import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class SearchResult {
    @JsonProperty("collectionId")
    private Long collectionId;
    @JsonProperty("collectionName")
    private String collectionName;
    @JsonProperty("artistName")
    private String artistName;
    @JsonProperty("feedUrl")
    private String feedUrl;
    @JsonProperty("artworkUrl600")
    private String artworkUrl;
    @JsonProperty("genres")
    private List<String> genres;
    @JsonProperty("color")
    private String color;

    public String getArtworkUrlEncrypted() throws Exception {
        return FastUrlCrypto.instance.encrypt(artworkUrl);
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    // getters/setters
    public Long getCollectionId() {
        return collectionId;
    }

    public void setCollectionId(Long collectionId) {
        this.collectionId = collectionId;
    }

    public String getCollectionName() {
        return collectionName;
    }

    public void setCollectionName(String collectionName) {
        this.collectionName = collectionName;
    }

    public String getArtistName() {
        return artistName;
    }

    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }

    public String getFeedUrl() {
        return feedUrl;
    }

    public void setFeedUrl(String feedUrl) {
        this.feedUrl = feedUrl;
    }

    public String getArtworkUrl() {
        return artworkUrl;
    }

    public void setArtworkUrl(String artworkUrl) {
        this.artworkUrl = artworkUrl;
    }

    public java.util.List<String> getGenres() {
        return genres;
    }

    public void setGenres(java.util.List<String> genres) {
        this.genres = genres;
    }
}
