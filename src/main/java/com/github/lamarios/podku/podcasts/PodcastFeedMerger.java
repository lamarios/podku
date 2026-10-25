/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeFile;
import com.github.lamarios.podku.episodes.EpisodePerson;
import com.github.lamarios.podku.episodes.EpisodeUtils;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Consumer;
import java.util.function.Function;

/**
 * Applies a freshly parsed feed onto a stored (managed) podcast.
 *
 * <p>The fresh podcast comes straight out of {@link PodcastParser} and is a self-contained graph of
 * new objects. The stored podcast is updated in place so that Hibernate dirty checking does the
 * work at commit time: no {@code merge()} is involved, new episodes are moved over as complete
 * object graphs (episode + files + people all pointing at each other) and child collections of
 * existing episodes are only replaced when their content actually changed.
 */
final class PodcastFeedMerger {
  private PodcastFeedMerger() {}

  /**
   * Outcome of a merge, for logging purposes.
   *
   * @param added number of episodes that did not exist yet
   * @param updated number of existing episodes found in the feed
   */
  record Result(int added, int updated) {}

  /**
   * Merges {@code fresh} into {@code target}.
   *
   * @param target the managed podcast to update
   * @param fresh the podcast freshly parsed from the feed
   * @return how many episodes were added / updated
   */
  static Result merge(Podcast target, Podcast fresh) {
    if (fresh.getName() != null && !fresh.getName().isBlank()) {
      target.setName(fresh.getName());
    }
    target.setDescription(fresh.getDescription());
    if (fresh.getArtworkUrl() != null) {
      target.setArtworkUrl(fresh.getArtworkUrl());
    }
    if (fresh.getColor() != null) {
      target.setColor(fresh.getColor());
    }
    target.setAuthor(fresh.getAuthor());
    target.setEtag(fresh.getEtag());
    target.setLastModified(fresh.getLastModified());
    target.setLink(fresh.getLink());

    if (target.getPeople() == null) {
      target.setPeople(new ArrayList<>());
    }
    replaceIfChanged(
        target.getPeople(),
        fresh.getPeople(),
        PodcastFeedMerger::podcastPersonSignature,
        person -> person.setPodcast(target));

    if (target.getEpisodes() == null) {
      target.setEpisodes(new ArrayList<>());
    }

    // if past refreshes stored duplicates, keep updating the first one only
    Map<String, Episode> existing = new HashMap<>();
    // episodes stored without a guid, by audio URL: lets a feed that starts publishing guids match
    // its already stored episodes instead of duplicating them
    Map<String, Episode> withoutGuidByAudio = new HashMap<>();
    for (Episode episode : target.getEpisodes()) {
      existing.putIfAbsent(EpisodeUtils.identityKey(episode), episode);
      if ((episode.getGuid() == null || episode.getGuid().isBlank())
          && episode.getAudioUrl() != null) {
        withoutGuidByAudio.putIfAbsent(episode.getAudioUrl(), episode);
      }
    }

    int added = 0;
    int updated = 0;
    for (Episode freshEpisode : fresh.getEpisodes()) {
      Episode episode = existing.get(EpisodeUtils.identityKey(freshEpisode));
      if (episode == null && freshEpisode.getAudioUrl() != null) {
        episode = withoutGuidByAudio.remove(freshEpisode.getAudioUrl());
      }
      if (episode == null) {
        freshEpisode.setPodcast(target);
        target.getEpisodes().add(freshEpisode);
        added++;
      } else {
        // an episode is matched at most once
        withoutGuidByAudio.remove(episode.getAudioUrl(), episode);
        mergeEpisode(episode, freshEpisode);
        updated++;
      }
    }

    return new Result(added, updated);
  }

  private static void mergeEpisode(Episode target, Episode fresh) {
    if (target.getFiles() == null) {
      target.setFiles(new ArrayList<>());
    }
    if (target.getPeople() == null) {
      target.setPeople(new ArrayList<>());
    }

    boolean audioChanged = !Objects.equals(target.getAudioUrl(), fresh.getAudioUrl());
    boolean filesChanged =
        replaceIfChanged(
            target.getFiles(),
            fresh.getFiles(),
            PodcastFeedMerger::fileSignature,
            file -> file.setEpisode(target));
    if (audioChanged || filesChanged) {
      target.setProcessed(false);
    }

    replaceIfChanged(
        target.getPeople(),
        fresh.getPeople(),
        PodcastFeedMerger::episodePersonSignature,
        person -> person.setEpisode(target));

    if (target.getGuid() == null || target.getGuid().isBlank()) {
      target.setGuid(fresh.getGuid());
    }
    target.setTitle(fresh.getTitle());
    target.setDescription(fresh.getDescription());
    target.setImageUrl(fresh.getImageUrl());
    target.setAudioUrl(fresh.getAudioUrl());
    target.setAudioType(fresh.getAudioType());
    target.setAudioLengthBytes(fresh.getAudioLengthBytes());
    target.setDurationSeconds(fresh.getDurationSeconds());
    target.setPubDateMillis(fresh.getPubDateMillis());
    target.setEpisodeType(fresh.getEpisodeType());
    target.setEpisodeNumber(fresh.getEpisodeNumber());
    target.setSeasonNumber(fresh.getSeasonNumber());
    target.setExplicit(fresh.getExplicit());
    target.setLink(fresh.getLink());
  }

  /**
   * Replaces the content of a managed child collection with the fresh children, but only when they
   * differ, to avoid deleting and re-inserting every row on every refresh.
   *
   * @return whether the collection was replaced
   */
  private static <T> boolean replaceIfChanged(
      List<T> target, List<T> fresh, Function<T, List<Object>> signature, Consumer<T> reparent) {
    List<T> source = fresh == null ? List.of() : fresh;
    if (target.stream().map(signature).toList().equals(source.stream().map(signature).toList())) {
      return false;
    }
    target.clear();
    for (T child : source) {
      reparent.accept(child);
      target.add(child);
    }
    return true;
  }

  private static List<Object> fileSignature(EpisodeFile f) {
    return Arrays.asList(f.getType(), f.getUrl(), f.getMime(), f.getLanguage(), f.getRel());
  }

  private static List<Object> episodePersonSignature(EpisodePerson p) {
    return Arrays.asList(p.getName(), p.getRole(), p.getGroup(), p.getImage(), p.getLink());
  }

  private static List<Object> podcastPersonSignature(PodcastPerson p) {
    return Arrays.asList(p.getName(), p.getRole(), p.getGroup(), p.getImage(), p.getLink());
  }
}
