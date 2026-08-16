/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import java.util.List;
import java.util.UUID;

public class PodcastLight {
    private UUID id;
    private String url;
    private String name;
    private String artworkUrl;
    private String description;
    private String author;
    private String link;
    private String color;
    private List<PodcastPerson> people;
    private String artworkEncrypted;

    public PodcastLight() {
    }

    public PodcastLight(Podcast podcast) {
        id = podcast.getId();
        url = podcast.getUrl();
        name = podcast.getName();
        artworkUrl = podcast.getArtworkUrl();
        description = podcast.getDescription();
        author = podcast.getAuthor();
        link = podcast.getLink();
        people = podcast.getPeople();
        color = podcast.getColor();
        try {
            artworkEncrypted = podcast.getArtworkEncrypted();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public String getArtworkEncrypted() {
        return artworkEncrypted;
    }

    public void setArtworkEncrypted(String artworkEncrypted) {
        this.artworkEncrypted = artworkEncrypted;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getArtworkUrl() {
        return artworkUrl;
    }

    public void setArtworkUrl(String artworkUrl) {
        this.artworkUrl = artworkUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public List<PodcastPerson> getPeople() {
        return people;
    }

    public void setPeople(List<PodcastPerson> people) {
        this.people = people;
    }
}
