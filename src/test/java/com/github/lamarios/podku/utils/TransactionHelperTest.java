package com.github.lamarios.podku.utils;

import static org.junit.jupiter.api.Assertions.*;

import com.github.lamarios.podku.TestContainerTest;
import com.github.lamarios.podku.podcasts.Podcast;
import com.github.lamarios.podku.podcasts.PodcastRepository;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionSynchronizationManager;

public class TransactionHelperTest extends TestContainerTest {
  @Autowired private PlatformTransactionManager transactionManager;
  @Autowired private PodcastRepository podcastRepository;

  private Podcast newPodcast(String name) {
    Podcast podcast = new Podcast();
    podcast.setName(name);
    podcast.setUrl("http://localhost/" + UUID.randomUUID());
    return podcast;
  }

  @Test
  public void testCommitsOnSuccess() {
    UUID id =
        TransactionHelper.doInNewTransaction(
                transactionManager, false, () -> podcastRepository.save(newPodcast("committed")))
            .getId();

    assertTrue(podcastRepository.findById(id).isPresent());
    assertFalse(TransactionSynchronizationManager.isActualTransactionActive());
  }

  @Test
  public void testRollsBackOnRuntimeException() {
    assertThrows(
        IllegalStateException.class,
        () ->
            TransactionHelper.doInNewTransaction(
                transactionManager,
                false,
                () -> {
                  podcastRepository.saveAndFlush(newPodcast("rolled back"));
                  throw new IllegalStateException("boom");
                }));

    assertTrue(podcastRepository.findAll().isEmpty());
    assertFalse(TransactionSynchronizationManager.isActualTransactionActive());
  }

  @Test
  public void testRollsBackAndReleasesThreadOnError() {
    assertThrows(
        OutOfMemoryError.class,
        () ->
            TransactionHelper.doInNewTransaction(
                transactionManager,
                false,
                () -> {
                  podcastRepository.saveAndFlush(newPodcast("rolled back"));
                  throw new OutOfMemoryError("simulated");
                }));

    assertTrue(podcastRepository.findAll().isEmpty());
    // nothing must stay bound to the thread, otherwise later "new" transactions would join it
    assertFalse(TransactionSynchronizationManager.isActualTransactionActive());
    assertTrue(TransactionSynchronizationManager.getResourceMap().isEmpty());

    // and the next transaction on this thread works and commits on its own
    TransactionHelper.doInNewTransaction(
        transactionManager, false, () -> podcastRepository.save(newPodcast("after error")));
    assertEquals(1, podcastRepository.findAll().size());
  }

  @Test
  public void testNestedCallRunsInItsOwnTransaction() {
    assertThrows(
        IllegalStateException.class,
        () ->
            TransactionHelper.doInNewTransaction(
                transactionManager,
                false,
                () -> {
                  podcastRepository.saveAndFlush(newPodcast("outer"));
                  TransactionHelper.doInNewTransaction(
                      transactionManager, false, () -> podcastRepository.save(newPodcast("inner")));
                  throw new IllegalStateException("outer fails after inner committed");
                }));

    var names = podcastRepository.findAll().stream().map(Podcast::getName).toList();
    assertEquals(java.util.List.of("inner"), names);
  }
}
