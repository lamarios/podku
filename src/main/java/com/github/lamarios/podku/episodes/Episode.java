/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.lamarios.podku.bookmarks.Bookmark;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastLight;
import com.github.lamarios.podku.transcripts.EpisodeTranscript;
import com.github.lamarios.podku.utils.FastUrlCrypto;
import com.google.common.hash.Hashing;
import jakarta.persistence.*;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "episodes")
public class Episode {
  @Id
  @GeneratedValue(strategy = GenerationType.UUID)
  private UUID id;

  private String title;
  private String description;
  private String audioUrl;
  private String audioType;
  private Long audioLengthBytes;
  private Long pubDateMillis;
  private Long durationSeconds;
  private double progress = 0;
  private String guid;
  private String imageUrl;
  private Integer seasonNumber;
  private Integer episodeNumber;
  private String episodeType;
  private Boolean explicit;
  private String link;
  private boolean processed = false;
  private Long timeUpdated;

  @ManyToOne
  @JoinColumn(name = "podcast_id")
  @JsonIgnore
  private Podcast podcast;

  @Transient private PodcastLight podcastLight;
  @Transient private String audioUrlEncrypted;

  @OneToMany(mappedBy = "episode", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<Chapter> chapters;

  @OneToMany(mappedBy = "episode", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<EpisodeFile> files;

  @OneToMany(mappedBy = "episode", cascade = CascadeType.ALL, orphanRemoval = true)
  @JsonIgnore
  private List<EpisodeTranscript> transcripts;

  @OneToMany(mappedBy = "episode", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<EpisodePerson> people;

  @OneToMany(mappedBy = "episode", cascade = CascadeType.ALL, orphanRemoval = true)
  @JsonIgnore
  private List<Bookmark> bookmarks;

  public double getProgress() {
    return progress;
  }

  public void setProgress(double progress) {
    this.progress = progress;
  }

  public boolean isProcessed() {
    return processed;
  }

  @PrePersist
  @PreUpdate
  public void onUpdate() {
    timeUpdated = System.currentTimeMillis();
  }

  @Transient
  @JsonProperty("podcast")
  public PodcastLight getPodcastLight() {
    if (podcast != null) {
      return new PodcastLight(podcast);
    } else {
      return podcastLight;
    }
  }

  public void setAudioUrlEncrypted(String audioUrlEncrypted) {
    this.audioUrlEncrypted = audioUrlEncrypted;
  }

  public String getAudioUrlEncrypted() throws Exception {
    if (audioUrlEncrypted != null) {
      return audioUrlEncrypted;
    } else {
      return FastUrlCrypto.instance.encrypt(audioUrl);
    }
  }

  @Transient
  @JsonProperty("podcast")
  public void setPodcastLight(PodcastLight podcastLight) {
    this.podcastLight = podcastLight;
  }

  public void setProcessed(boolean processed) {
    this.processed = processed;
  }

  public List<Bookmark> getBookmarks() {
    return bookmarks;
  }

  public void setBookmarks(List<Bookmark> bookmarks) {
    this.bookmarks = bookmarks;
  }

  public Integer getEpisodeNumber() {
    return episodeNumber;
  }

  public void setEpisodeNumber(Integer episodeNumber) {
    this.episodeNumber = episodeNumber;
  }

  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getAudioUrl() {
    return audioUrl;
  }

  public void setAudioUrl(String audioUrl) {
    this.audioUrl = audioUrl;
  }

  public String getAudioType() {
    return audioType;
  }

  public void setAudioType(String audioType) {
    this.audioType = audioType;
  }

  public Long getAudioLengthBytes() {
    return audioLengthBytes;
  }

  public void setAudioLengthBytes(Long audioLengthBytes) {
    this.audioLengthBytes = audioLengthBytes;
  }

  public Long getPubDateMillis() {
    return pubDateMillis;
  }

  public void setPubDateMillis(Long pubDateMillis) {
    this.pubDateMillis = pubDateMillis;
  }

  public Long getDurationSeconds() {
    return durationSeconds;
  }

  public void setDurationSeconds(Long durationSeconds) {
    this.durationSeconds = durationSeconds;
  }

  public String getGuid() {
    return guid;
  }

  public void setGuid(String guid) {
    this.guid = guid;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public Integer getSeasonNumber() {
    return seasonNumber;
  }

  public void setSeasonNumber(Integer seasonNumber) {
    this.seasonNumber = seasonNumber;
  }

  public String getEpisodeType() {
    return episodeType;
  }

  public void setEpisodeType(String episodeType) {
    this.episodeType = episodeType;
  }

  public Boolean getExplicit() {
    return explicit;
  }

  public void setExplicit(Boolean explicit) {
    this.explicit = explicit;
  }

  public String getLink() {
    return link;
  }

  public void setLink(String link) {
    this.link = link;
  }

  public Podcast getPodcast() {
    return podcast;
  }

  public void setPodcast(Podcast podcast) {
    this.podcast = podcast;
  }

  public List<Chapter> getChapters() {
    return chapters;
  }

  public void setChapters(List<Chapter> chapters) {
    this.chapters = chapters;
  }

  public List<EpisodeFile> getFiles() {
    return files;
  }

  public void setFiles(List<EpisodeFile> files) {
    this.files = files;
  }

  public List<EpisodeTranscript> getTranscripts() {
    return transcripts;
  }

  public void setTranscripts(List<EpisodeTranscript> transcripts) {
    this.transcripts = transcripts;
  }

  public List<EpisodePerson> getPeople() {
    return people;
  }

  public void setPeople(List<EpisodePerson> people) {
    this.people = people;
  }

  @Transient
  @JsonIgnore
  public String getAudioUrlHash() {
    return Hashing.sha256().hashString(getAudioUrl(), StandardCharsets.UTF_8).toString();
  }

  public Long getTimeUpdated() {
    return timeUpdated;
  }

  public void setTimeUpdated(Long timeUpdated) {
    this.timeUpdated = timeUpdated;
  }
}
