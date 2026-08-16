/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.lamarios.podku.models.Person;
import com.github.lamarios.podku.utils.FastUrlCrypto;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "episode_people")
public class EpisodePerson implements Person {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String name;
    private String role;
    @Column(name = "`group`")
    private String group;
    private String image;
    private String link;
    @ManyToOne
    @JoinColumn(name = "episode_id")
    @JsonIgnore
    private Episode episode;
    @Transient
    private String imageEncrypted;

    public String getImageEncrypted() throws Exception {
        if (imageEncrypted != null) {
            return imageEncrypted;
        } else {
            return FastUrlCrypto.instance.encrypt(image);
        }
    }

    public void setImageEncrypted(String imageEncrypted) {
        this.imageEncrypted = imageEncrypted;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Episode getEpisode() {
        return episode;
    }

    public void setEpisode(Episode episode) {
        this.episode = episode;
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
