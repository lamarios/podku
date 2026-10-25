/* (C)2026 */
package com.github.lamarios.podku.podcasts;

import static com.github.lamarios.podku.mock.MockFeeds.feed;
import static com.github.lamarios.podku.mock.MockFeeds.item;
import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.episodes.Episode;
import com.github.lamarios.podku.episodes.EpisodeFile;
import com.github.lamarios.podku.episodes.EpisodePerson;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.mock.MockFeedController;
import com.github.lamarios.podku.mock.MockFeedController.DynamicResponse;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.transcripts.EpisodeTranscriptRepository;
import com.github.lamarios.podku.utils.BackgroundTasks;
import com.github.lamarios.podku.utils.TransactionHelper;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.PlatformTransactionManager;

/** Tests the podcast refresh flow: conditional fetch, parsing into a fresh graph and merging. */
public class PodcastRefreshTest extends TestContainerTest {
  @Autowired private PodcastController podcastController;
  @Autowired private PodcastService podcastService;
  @Autowired private PodcastParser parser;
  @Autowired private PodcastRepository podcastRepository;
  @Autowired private EpisodeRepository episodeRepository;
  @Autowired private EpisodeTranscriptRepository episodeTranscriptRepository;
  @Autowired private PlatformTransactionManager transactionManager;

  private void waitForBackgroundTasks() throws InterruptedException {
    long timeout = System.currentTimeMillis() + 10000;
    while (BackgroundTasks.getInFlight().get() > 0 && System.currentTimeMillis() < timeout) {
      Thread.sleep(50);
    }
  }

  /** Serves {@code xml} at {@code /mock/dynamic/{name}} and subscribes to it. */
  private UUID subscribe(String name, String xml) throws InterruptedException {
    MockFeedController.serve(name, xml);
    SearchResult result = new SearchResult();
    result.setFeedUrl(getBaseUrl() + "/mock/dynamic/" + name);
    result.setCollectionName(name);
    Podcast podcast = podcastController.subscribeToPodcast(result);
    assertNotNull(podcast);
    waitForBackgroundTasks();
    return podcast.getId();
  }

  /** Serves the new version of the feed and refreshes the podcast from it. */
  private void refresh(UUID id, String name, String xml) {
    MockFeedController.serve(name, xml);
    podcastService.refreshPodcast(id);
  }

  private String transcript(String version) {
    return getBaseUrl() + "/mock/transcript.vtt?v=" + version;
  }

  /** Snapshot of a stored episode. */
  private record Stored(
      String title,
      String guid,
      boolean processed,
      double progress,
      List<UUID> fileIds,
      List<String> fileUrls,
      List<String> people) {}

  private List<Stored> stored(UUID id) {
    return TransactionHelper.doInNewTransaction(
        transactionManager,
        true,
        () ->
            podcastRepository.findById(id).orElseThrow().getEpisodes().stream()
                .map(
                    e ->
                        new Stored(
                            e.getTitle(),
                            e.getGuid(),
                            e.isProcessed(),
                            e.getProgress(),
                            e.getFiles().stream().map(EpisodeFile::getId).toList(),
                            e.getFiles().stream().map(EpisodeFile::getUrl).toList(),
                            e.getPeople().stream().map(EpisodePerson::getName).toList()))
                .sorted(Comparator.comparing(Stored::title))
                .toList());
  }

  private List<String> titles(UUID id) {
    return stored(id).stream().map(Stored::title).toList();
  }

  private void markAllProcessed(UUID id) {
    TransactionHelper.doInNewTransaction(
        transactionManager,
        false,
        () ->
            podcastRepository
                .findById(id)
                .orElseThrow()
                .getEpisodes()
                .forEach(e -> e.setProcessed(true)));
  }

  @Test
  public void testRefreshAddsNewEpisodesAndUpdatesChangedFiles() throws Exception {
    UUID id =
        subscribe(
            "feed",
            feed("Refresh", item("a", "a").transcript(transcript("a1"), "en"), item("b", "b")));
    markAllProcessed(id);

    refresh(
        id,
        "feed",
        feed(
            "Refresh",
            item("a", "a").transcript(transcript("a2"), "en"),
            item("b", "b"),
            item("c", "c").transcript(transcript("c1"), "en")));

    List<Stored> episodes = stored(id);
    assertEquals(List.of("a", "b", "c"), episodes.stream().map(Stored::title).toList());
    assertEquals(List.of(transcript("a2")), episodes.get(0).fileUrls());
    assertFalse(episodes.get(0).processed(), "changed files must trigger reprocessing");
    assertTrue(episodes.get(1).processed(), "unchanged episode must not be reprocessed");
    assertEquals(List.of(transcript("c1")), episodes.get(2).fileUrls());
    assertFalse(episodes.get(2).processed());
  }

  @Test
  public void testUnchangedRefreshDoesNotRewriteChildren() throws Exception {
    String xml =
        feed(
            "Unchanged",
            item("a", "a")
                .transcript(transcript("1"), "en")
                .transcript(transcript("2"), "fr")
                .person("Alice", "host"));
    UUID id = subscribe("feed", xml);
    markAllProcessed(id);
    List<Stored> before = stored(id);

    refresh(id, "feed", xml);

    // same row ids: the files were not deleted and re-inserted
    assertEquals(before, stored(id));
  }

  @Test
  public void testAudioUrlChangeTriggersReprocessing() throws Exception {
    UUID id = subscribe("feed", feed("Audio", item("a", "a").audio("http://localhost/v1.mp3")));
    markAllProcessed(id);

    refresh(id, "feed", feed("Audio", item("a", "a").audio("http://localhost/v2.mp3")));

    assertFalse(stored(id).getFirst().processed());
  }

  @Test
  public void testEpisodeAndPodcastDataIsUpdated() throws Exception {
    UUID id = subscribe("feed", feed("Old name", item("a", "Old title").person("Alice", "host")));

    refresh(id, "feed", feed("New name", item("a", "New title").person("Bob", "guest")));

    Stored episode = stored(id).getFirst();
    assertEquals("New title", episode.title());
    assertEquals(List.of("Bob"), episode.people());
    assertEquals("New name", podcastController.getPodcast(id.toString()).getName());
  }

  @Test
  public void testFeedWithoutGuidsCanBeRefreshedRepeatedly() throws Exception {
    UUID id = subscribe("feed", feed("No guids", item(null, "a"), item("b", "b")));

    refresh(id, "feed", feed("No guids", item(null, "a"), item("b", "b")));
    refresh(id, "feed", feed("No guids", item(null, "a"), item("b", "b"), item(null, "n")));

    assertEquals(List.of("a", "b", "n"), titles(id));
  }

  @Test
  public void testFeedStartingToPublishGuidsDoesNotDuplicateEpisodes() throws Exception {
    UUID id = subscribe("feed", feed("Late guids", item(null, "a"), item(null, "b")));

    refresh(id, "feed", feed("Late guids", item("guid-a", "a"), item("guid-b", "b")));

    List<Stored> episodes = stored(id);
    assertEquals(List.of("a", "b"), episodes.stream().map(Stored::title).toList());
    assertEquals(List.of("guid-a", "guid-b"), episodes.stream().map(Stored::guid).toList());
  }

  @Test
  public void testDuplicateItemsInFeedAreStoredOnce() throws Exception {
    UUID id = subscribe("feed", feed("Dups", item("a", "a"), item("a", "a"), item("b", "b")));

    refresh(
        id, "feed", feed("Dups", item("a", "a"), item("b", "b"), item("b", "b"), item("c", "c")));

    assertEquals(List.of("a", "b", "c"), titles(id));
  }

  @Test
  public void testUnchangedFeedIsNotRefetchedWithEtag() throws Exception {
    String xml = feed("Etag", item("a", "a"));
    UUID id = subscribe("feed", xml);
    MockFeedController.serve(
        "feed", new DynamicResponse(200, MediaType.APPLICATION_XML_VALUE, xml, "\"v1\"", null));
    podcastService.refreshPodcast(id); // stores the etag
    int fullResponses = MockFeedController.fullResponses("feed");

    podcastService.refreshPodcast(id);
    assertEquals(fullResponses, MockFeedController.fullResponses("feed"), "expected a 304");

    MockFeedController.serve(
        "feed",
        new DynamicResponse(
            200,
            MediaType.APPLICATION_XML_VALUE,
            feed("Etag", item("a", "a"), item("b", "b")),
            "\"v2\"",
            null));
    podcastService.refreshPodcast(id);

    assertEquals(fullResponses + 1, MockFeedController.fullResponses("feed"));
    assertEquals(List.of("a", "b"), titles(id));
    assertEquals("\"v2\"", podcastRepository.findById(id).orElseThrow().getEtag());
  }

  @Test
  public void testUnchangedFeedIsNotRefetchedWithLastModified() throws Exception {
    String xml = feed("Last modified", item("a", "a"));
    UUID id = subscribe("feed", xml);
    String date = "Mon, 01 Jan 2024 12:00:00 GMT";
    MockFeedController.serve(
        "feed", new DynamicResponse(200, MediaType.APPLICATION_XML_VALUE, xml, null, date));
    podcastService.refreshPodcast(id);
    int fullResponses = MockFeedController.fullResponses("feed");

    podcastService.refreshPodcast(id);

    assertEquals(fullResponses, MockFeedController.fullResponses("feed"), "expected a 304");
    assertEquals(date, podcastRepository.findById(id).orElseThrow().getLastModified());
  }

  @Test
  public void testFailedMergeKeepsPreviousCacheHeaders() throws Exception {
    UUID id = subscribe("feed", feed("Failing merge", item("a", "a")));
    TransactionHelper.doInNewTransaction(
        transactionManager,
        false,
        () -> podcastRepository.findById(id).orElseThrow().setEtag("\"old\""));

    Podcast broken = new Podcast();
    broken.setEtag("\"new\"");
    broken.setEpisodes(null); // makes the merge fail
    assertThrows(RuntimeException.class, () -> podcastService.applyFeed(id, broken));

    // the old etag stays, so the next refresh fetches the feed again instead of getting a 304
    assertEquals("\"old\"", podcastRepository.findById(id).orElseThrow().getEtag());
  }

  @Test
  public void testRefreshOfDeletedPodcastDoesNothing() {
    assertDoesNotThrow(() -> podcastService.refreshPodcast(UUID.randomUUID()));
  }

  @Test
  public void testRefreshDoesNotOverwriteConcurrentProgress() throws Exception {
    UUID id = subscribe("feed", feed("Progress", item("a", "Old title")));
    UUID episodeId =
        TransactionHelper.doInNewTransaction(
            transactionManager,
            true,
            () -> podcastRepository.findById(id).orElseThrow().getEpisodes().getFirst().getId());
    MockFeedController.serve("feed", feed("Progress", item("a", "New title")));
    Podcast fresh = new Podcast();
    fresh.setUrl(getBaseUrl() + "/mock/dynamic/feed");
    Podcast parsed = parser.parseUrl(fresh);

    TransactionHelper.doInNewTransaction(
        transactionManager,
        false,
        () -> {
          Podcast podcast = podcastRepository.findById(id).orElseThrow();
          PodcastFeedMerger.merge(podcast, parsed);
          // a client saves its playback progress while the refresh transaction is still open
          TransactionHelper.doInNewTransaction(
              transactionManager,
              false,
              () -> episodeRepository.findById(episodeId).orElseThrow().setProgress(42));
        });

    Episode episode = episodeRepository.findById(episodeId).orElseThrow();
    assertEquals("New title", episode.getTitle());
    assertEquals(42, episode.getProgress(), "the refresh must only write the columns it changed");
  }

  @Test
  public void testRefreshPodcastsContinuesAfterFailingFeedAndProcessesNewEpisodes()
      throws Exception {
    UUID broken = subscribe("broken", feed("Broken", item("x", "x")));
    UUID good = subscribe("good", feed("Good", item("a", "a")));
    MockFeedController.serve(
        "broken", new DynamicResponse(500, MediaType.TEXT_PLAIN_VALUE, "down", null, null));
    MockFeedController.serve(
        "good",
        feed(
            "Good",
            item("a", "a"),
            item("b", "b").transcript(getBaseUrl() + "/mock/transcript.vtt", "en")));

    podcastService.refreshPodcasts();
    waitForBackgroundTasks();

    assertEquals(List.of("x"), titles(broken), "a failing feed keeps its episodes");
    Stored b = stored(good).get(1);
    assertEquals("b", b.title());
    assertTrue(b.processed(), "new episodes are processed after the refresh");
    List<String> languages =
        TransactionHelper.doInNewTransaction(
            transactionManager,
            true,
            () ->
                episodeTranscriptRepository.findDistinctLanguagesForEpisode(
                    podcastRepository.findById(good).orElseThrow().getEpisodes().stream()
                        .filter(e -> e.getTitle().equals("b"))
                        .findFirst()
                        .orElseThrow()));
    assertEquals(List.of("en"), languages);
  }
}
