/* (C)2026 */
package com.github.lamarios.podku.utils;

import java.util.function.Supplier;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;

/** Helper for running a block of work inside an explicit Spring-managed database transaction. */
public class TransactionHelper {
  private static final Logger log = LogManager.getLogger();

  /**
   * Runs {@code runnable} in a brand-new transaction (suspending any transaction already bound to
   * the current thread), committing on success and rolling back (then rethrowing) if it throws.
   *
   * <p>Rollback also happens for {@link Error}s (e.g. {@link OutOfMemoryError}): otherwise the
   * transaction and its persistence context would stay bound to the thread forever and every later
   * call on that thread would silently join it instead of starting a new one.
   *
   * @param transactionManager the manager that owns the transaction
   * @param readonly whether the transaction should be marked read-only
   * @param runnable the work to execute inside the transaction
   */
  public static void doInNewTransaction(
      PlatformTransactionManager transactionManager, boolean readonly, Runnable runnable) {
    doInNewTransaction(
        transactionManager,
        readonly,
        () -> {
          runnable.run();
          return null;
        });
  }

  /**
   * Runs {@code runnable} in a brand-new transaction (suspending any transaction already bound to
   * the current thread), committing on success and rolling back (then rethrowing) if it throws,
   * including on {@link Error}s.
   *
   * @param transactionManager the manager that owns the transaction
   * @param readonly whether the transaction should be marked read-only
   * @param runnable the work to execute inside the transaction; its result is returned on success
   * @param <T> the type of the operation's result
   * @return the value produced by {@code runnable}
   */
  public static <T> T doInNewTransaction(
      PlatformTransactionManager transactionManager, boolean readonly, Supplier<T> runnable) {
    TransactionTemplate template = new TransactionTemplate(transactionManager);
    template.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
    template.setReadOnly(readonly);
    try {
      return template.execute(_ -> runnable.get());
    } catch (RuntimeException | Error e) {
      log.error("Failed to run operation within a transaction, rolled back", e);
      throw e;
    }
  }
}
