/* (C)2026 */
package com.github.lamarios.podku.episodes;

import com.google.common.hash.Hashing;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Static helpers for working with episode media files. */
public class EpisodeUtils {
  private static final Logger log = LogManager.getLogger();

  /**
   * Key used to recognise the same episode across feed refreshes: the RSS guid when present, the
   * default media URL otherwise and the title as a last resort (some feeds do not provide guids).
   *
   * @param e the episode
   * @return a non-null identity key
   */
  public static String identityKey(Episode e) {
    if (e.getGuid() != null && !e.getGuid().isBlank()) {
      return "guid:" + e.getGuid();
    }
    String mediaUrl = defaultMediaUrl(e);
    if (mediaUrl != null && !mediaUrl.isBlank()) {
      return "audio:" + mediaUrl;
    }
    return "title:" + e.getTitle();
  }

  /**
   * The main media of an episode: the media file flagged as default (the item's {@code
   * <enclosure>}), or the first media file when none is.
   *
   * @param e the episode, its files must be loaded
   * @return the default media file, null if the episode has no media
   */
  public static EpisodeFile defaultMedia(Episode e) {
    if (e.getFiles() == null) {
      return null;
    }
    // min keeps the first of equal elements, so the feed order is the tie-breaker
    return e.getFiles().stream()
        .filter(f -> f.getType() != null && f.getType().isMedia())
        .min(Comparator.comparing((EpisodeFile f) -> !Boolean.TRUE.equals(f.getDefaultMedia())))
        .orElse(null);
  }

  /**
   * The URL of the main media of an episode, see {@link #defaultMedia(Episode)}.
   *
   * @param e the episode, its files must be loaded
   * @return the default media URL, null if the episode has no media
   */
  public static String defaultMediaUrl(Episode e) {
    EpisodeFile media = defaultMedia(e);
    return media != null ? media.getUrl() : null;
  }

  /**
   * Name of a media file in the episode cache folder: the SHA-256 hash of its URL, which is also
   * what the URL proxy looks up when serving a cached file.
   *
   * @param media the media file
   * @return the cache file name
   */
  public static String mediaCacheKey(EpisodeFile media) {
    return Hashing.sha256().hashString(media.getUrl(), StandardCharsets.UTF_8).toString();
  }

  /**
   * Downloads an episode media file into the cache folder, reusing an existing complete file when
   * present. The cache key is the media URL hash, see {@link #mediaCacheKey(EpisodeFile)}.
   *
   * @param media the media file to fetch, usually the episode {@link #defaultMedia(Episode)}
   * @param episodeCacheFolder directory used to store downloaded media files
   * @return the local path of the downloaded (or already cached) media file
   * @throws IOException if the download fails or the file size does not match
   */
  public static Path downloadEpisode(EpisodeFile media, Path episodeCacheFolder)
      throws IOException {
    Episode e = media.getEpisode();
    var episodeHash = mediaCacheKey(media);

    log.info("Downloading episode: {} from podcast {}", e.getTitle(), e.getPodcast().getName());
    Path episodeFile = episodeCacheFolder.resolve(episodeHash);

    try {
      URL url = URI.create(media.getUrl()).toURL();
      URLConnection connection = url.openConnection();
      long length = connection.getContentLengthLong();

      if (episodeFile.toFile().exists()) {
        if (length == Files.size(episodeFile)) {
          log.info("Episode {} already exists", episodeHash);
          return episodeFile;
        } else {
          log.info("File exists, but size differs, redownloading...");
        }
      }

      log.info("expected length: ~{}MB", length / 1_000_000);
      IOUtils.copy(url, episodeFile.toFile());

      long downloadedSize = Files.size(episodeFile);
      log.info("Downloaded length: ~{}MB", downloadedSize / 1_000_000);
      if (downloadedSize != length) {
        log.info("File size is different, {} vs expected {}", downloadedSize, length);
        throw new IOException("Incorrect file size");
      }

      log.info("Download finished for episode: {}", e.getTitle());

      return episodeFile;
    } catch (IOException ex) {
      log.error("Couldn't download episode {}", e.getTitle(), ex);
      // we delete anything that exists
      if (episodeFile.toFile().exists()) {
        episodeFile.toFile().delete();
      }
      throw ex;
    }
  }
}
