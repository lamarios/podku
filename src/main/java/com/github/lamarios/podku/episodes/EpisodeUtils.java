/* (C)2026 */
package com.github.lamarios.podku.episodes;

import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import org.apache.commons.io.IOUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Static helpers for working with episode audio files. */
public class EpisodeUtils {
  private static final Logger log = LogManager.getLogger();

  /**
   * Downloads the episode audio into the cache folder, reusing an existing complete file when
   * present. The cache key is the episode's audio-URL hash.
   *
   * @param e the episode whose audio should be fetched
   * @param episodeCacheFolder directory used to store downloaded audio files
   * @return the local path of the downloaded (or already cached) audio file
   * @throws IOException if the download fails or the file size does not match
   */
  public static Path downloadEpisode(Episode e, Path episodeCacheFolder) throws IOException {
    var episodeHash = e.getAudioUrlHash();

    log.info("Downloading episode: {} from podcast {}", e.getTitle(), e.getPodcast().getName());
    Path episodeFile = episodeCacheFolder.resolve(episodeHash);

    try {
      URL url = URI.create(e.getAudioUrl()).toURL();
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
