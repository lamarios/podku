package com.github.lamarios.podku.utils;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import java.util.function.Supplier;

public class TransactionHelper {
    private final static Logger log = LogManager.getLogger();

    public static void doInNewTransaction(PlatformTransactionManager transactionManager, boolean readonly, Runnable runnable) {
        DefaultTransactionDefinition definition = new DefaultTransactionDefinition();
        definition.setReadOnly(readonly);
        TransactionStatus status = transactionManager.getTransaction(definition);
        try {
            runnable.run();
            transactionManager.commit(status);
        } catch (Exception e) {
            if (!status.isCompleted()) {
                transactionManager.rollback(status);
                log.error("Failed to run operation within a transaction, rolling back", e);
            }
            // handle exception
            throw e;
        }
    }
    public static <T> T doInNewTransaction(PlatformTransactionManager transactionManager, boolean readonly, Supplier<T> runnable) {
        DefaultTransactionDefinition definition = new DefaultTransactionDefinition();
        definition.setReadOnly(readonly);
        TransactionStatus status = transactionManager.getTransaction(definition);
        try {
            var result = runnable.get();
            transactionManager.commit(status);
            return result;
        } catch (Exception e) {
            if (!status.isCompleted()) {
                transactionManager.rollback(status);
                log.error("Failed to run operation within a transaction, rolling back", e);
            }
            // handle exception
            throw e;
        }
    }
}
