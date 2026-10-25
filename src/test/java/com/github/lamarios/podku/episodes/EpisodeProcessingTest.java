package com.github.lamarios.podku.episodes;

import static com.github.lamarios.podku.mock.MockFeeds.feed;
import static com.github.lamarios.podku.mock.MockFeeds.item;
import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.mock.MockFeedController;
import com.github.lamarios.podku.mock.MockFeedController.DynamicResponse;
import com.github.lamarios.podku.mock.MockFeeds;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastController;
import com.github.lamarios.podku.podcasts.PodcastRepository;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.transcripts.EpisodeTranscriptRepository;
import com.github.lamarios.podku.utils.BackgroundTasks;
import com.github.lamarios.podku.utils.TransactionHelper;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.transaction.PlatformTransactionManager;

/** Tests the background processing of episodes (chapters and transcripts). */
public class EpisodeProcessingTest extends TestContainerTest {
  @Autowired private PodcastController podcastController;
  @Autowired private EpisodeService episodeService;
  @Autowired private EpisodeRepository episodeRepository;
  @Autowired private PodcastRepository podcastRepository;
  @Autowired private EpisodeTranscriptRepository episodeTranscriptRepository;
  @Autowired private PlatformTransactionManager transactionManager;

  private void waitForBackgroundTasks() throws InterruptedException {
    long timeout = System.currentTimeMillis() + 10000;
    while (BackgroundTasks.getInFlight().get() > 0 && System.currentTimeMillis() < timeout) {
      Thread.sleep(50);
    }
  }

  /** Subscribes to a single episode feed and waits for its processing to finish. */
  private UUID subscribe(MockFeeds.Item item) throws InterruptedException {
    MockFeedController.serve("feed", feed("Processing", item));
    SearchResult result = new SearchResult();
    result.setFeedUrl(getBaseUrl() + "/mock/dynamic/feed");
    result.setCollectionName("Processing");
    Podcast podcast = podcastController.subscribeToPodcast(result);
    assertNotNull(podcast);
    waitForBackgroundTasks();
    return podcast.getEpisodes().getFirst().getId();
  }

  /** Snapshot of an episode's processing state. */
  private record State(boolean processed, int chapters, List<String> transcriptLanguages) {}

  private State state(UUID episodeId) {
    return TransactionHelper.doInNewTransaction(
        transactionManager,
        true,
        () -> {
          Episode episode = episodeRepository.findById(episodeId).orElseThrow();
          return new State(
              episode.isProcessed(),
              episode.getChapters() == null ? 0 : episode.getChapters().size(),
              episodeTranscriptRepository.findDistinctLanguagesForEpisode(episode));
        });
  }

  private String vtt() {
    return getBaseUrl() + "/mock/transcript.vtt";
  }

  private String chapters() {
    return getBaseUrl() + "/mock/chapters.json";
  }

  private void serveChapters(int status, String contentType, String body) {
    MockFeedController.serve(
        "chapters", new DynamicResponse(status, contentType, body, null, null));
  }

  private String dynamicChapters() {
    return getBaseUrl() + "/mock/dynamic/chapters";
  }

  @Test
  public void testEpisodeIsFullyProcessed() throws Exception {
    UUID id = subscribe(item("a", "a").chapters(chapters()).transcript(vtt(), "en"));

    assertEquals(new State(true, 3, List.of("en")), state(id));
  }

  @Test
  public void testEpisodeWithoutFilesIsMarkedProcessed() throws Exception {
    UUID id = subscribe(item("a", "a"));

    assertTrue(state(id).processed());
  }

  @Test
  public void testMissingChaptersLeaveEpisodeUnprocessedButKeepTranscripts() throws Exception {
    UUID id =
        subscribe(
            item("a", "a")
                .chapters(getBaseUrl() + "/mock/dynamic/does-not-exist")
                .transcript(vtt(), "en"));

    assertEquals(new State(false, 0, List.of("en")), state(id));
  }

  @Test
  public void testInvalidChaptersLeaveEpisodeUnprocessed() throws Exception {
    serveChapters(200, MediaType.APPLICATION_JSON_VALUE, "this is not json");
    UUID id = subscribe(item("a", "a").chapters(dynamicChapters()).transcript(vtt(), "en"));

    assertEquals(new State(false, 0, List.of("en")), state(id));
  }

  @Test
  public void testUnreachableFilesLeaveEpisodeUnprocessed() throws Exception {
    UUID id =
        subscribe(
            item("a", "a")
                .chapters("http://localhost:1/chapters.json")
                .transcript("http://localhost:1/transcript.vtt", "en"));

    assertEquals(new State(false, 0, List.of()), state(id));
  }

  @Test
  public void testMissingTranscriptLeavesEpisodeUnprocessed() throws Exception {
    UUID id =
        subscribe(
            item("a", "a")
                .chapters(chapters())
                .transcript(vtt(), "en")
                .transcript(getBaseUrl() + "/mock/dynamic/does-not-exist", "fr"));

    assertEquals(new State(false, 3, List.of("en")), state(id));
  }

  @Test
  public void testTemporaryFailureIsRetried() throws Exception {
    serveChapters(503, MediaType.TEXT_PLAIN_VALUE, "temporarily down");
    UUID id = subscribe(item("a", "a").chapters(dynamicChapters()).transcript(vtt(), "en"));
    assertEquals(new State(false, 0, List.of("en")), state(id));

    // the chapters come back
    serveChapters(
        200,
        MediaType.APPLICATION_JSON_VALUE,
        """
        {"version": "1.2.0", "chapters": [{"startTime": 0.0, "title": "Intro"}]}
        """);
    episodeService.processUnprocessedEpisodes().join();

    assertEquals(new State(true, 1, List.of("en")), state(id));
  }

  @Test
  public void testRetryDoesNotDuplicateTranscripts() throws Exception {
    serveChapters(503, MediaType.TEXT_PLAIN_VALUE, "temporarily down");
    UUID id = subscribe(item("a", "a").chapters(dynamicChapters()).transcript(vtt(), "en"));
    int transcriptLines = transcriptLines(id);

    episodeService.processUnprocessedEpisodes().join();
    episodeService.processUnprocessedEpisodes().join();

    assertFalse(state(id).processed());
    assertEquals(transcriptLines, transcriptLines(id));
  }

  @Test
  public void testProcessPodcastOnlyProcessesUnprocessedEpisodes() throws Exception {
    UUID id = subscribe(item("a", "a").chapters(chapters()));
    assertTrue(state(id).processed());
    // if the episode were reprocessed, the broken chapters URL would mark it unprocessed again
    UUID podcastId =
        TransactionHelper.doInNewTransaction(
            transactionManager,
            false,
            () -> {
              Episode episode = episodeRepository.findById(id).orElseThrow();
              episode.getFiles().getFirst().setUrl(getBaseUrl() + "/mock/dynamic/does-not-exist");
              return episode.getPodcast().getId();
            });

    assertEquals(podcastId, episodeService.processPodcast(podcastId).join());

    assertTrue(state(id).processed());
  }

  @Test
  public void testUnprocessedIdQueries() throws Exception {
    UUID id = subscribe(item("a", "a").chapters(getBaseUrl() + "/mock/dynamic/does-not-exist"));
    UUID podcastId = podcastRepository.findAll().getFirst().getId();

    assertEquals(List.of(id), episodeRepository.findUnprocessedIds());
    assertEquals(List.of(id), episodeRepository.findUnprocessedIdsByPodcastId(podcastId));
    assertEquals(List.of(), episodeRepository.findUnprocessedIdsByPodcastId(UUID.randomUUID()));
  }

  private int transcriptLines(UUID episodeId) {
    return TransactionHelper.doInNewTransaction(
        transactionManager,
        true,
        () -> episodeRepository.findById(episodeId).orElseThrow().getTranscripts().size());
  }
}
