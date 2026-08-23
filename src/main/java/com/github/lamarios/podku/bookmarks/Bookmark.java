package com.github.lamarios.podku.bookmarks;

import com.github.lamarios.podku.episodes.Episode;
import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "episode_bookmarks")
public class Bookmark {

  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  private UUID id;

  private long time;

  @ManyToOne
  @JoinColumn(name = "episode_id")
  private Episode episode;

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public long getTime() {
    return time;
  }

  public void setTime(long time) {
    this.time = time;
  }

  public Episode getEpisode() {
    return episode;
  }

  public void setEpisode(Episode episode) {
    this.episode = episode;
  }
}
