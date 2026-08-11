/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.lamarios.podku.models.Person;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "podcast_people")
public class PodcastPerson implements Person {
    private String name;
    private String role;
    @Column(name = "`group`")
    private String group;
    private String image;
    private String link;
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    @ManyToOne
    @JoinColumn(name = "podcast_id")
    @JsonIgnore
    private Podcast podcast;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Podcast getPodcast() {
        return podcast;
    }

    public void setPodcast(Podcast podcast) {
        this.podcast = podcast;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String getRole() {
        return role;
    }

    @Override
    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String getGroup() {
        return group;
    }

    @Override
    public void setGroup(String group) {
        this.group = group;
    }

    @Override
    public String getImage() {
        return image;
    }

    @Override
    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String getLink() {
        return link;
    }

    @Override
    public void setLink(String link) {
        this.link = link;
    }
}
