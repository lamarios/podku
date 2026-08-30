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

  private Long time;

  private String topic;

  @ManyToOne
  @JoinColumn(name = "episode_id")
  private Episode episode;

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public Long getTime() {
    return time;
  }

  public String getTopic() {
    return topic;
  }

  public void setTopic(String topic) {
    this.topic = topic;
  }

  public void setTime(Long time) {
    this.time = time;
  }

  public Episode getEpisode() {
    return episode;
  }

  public void setEpisode(Episode episode) {
    this.episode = episode;
  }
}
