/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "episode_chapters")
public class Chapter {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private Double startTime;
    private String title;
    private String img;
    private Boolean toc = true;
    private Double endTime;
    @ManyToOne
    @JoinColumn(name = "episode_id")
    @JsonIgnore
    private Episode episode;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Double getStartTime() {
        return startTime;
    }

    public void setStartTime(Double startTime) {
        this.startTime = startTime;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public Boolean getToc() {
        return toc;
    }

    public void setToc(Boolean toc) {
        this.toc = toc;
    }

    public Double getEndTime() {
        return endTime;
    }

    public void setEndTime(Double endTime) {
        this.endTime = endTime;
    }

    public Episode getEpisode() {
        return episode;
    }

    public void setEpisode(Episode episode) {
        this.episode = episode;
    }
}
