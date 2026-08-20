/* (C)2026 */
package com.github.lamarios.podku.websockets;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.utils.TransactionHelper;
import java.io.IOException;
import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

@Component
public class WebSocketSessionManager {
  private final Logger log = LogManager.getLogger();
  private final Map<WebSocketSession, WebsocketClient> sessions = new ConcurrentHashMap<>();
  private final ObjectMapper objectMapper = new ObjectMapper();
  private final EpisodeRepository episodeRepository;
  private final PlatformTransactionManager transactionManager;
  private PlayerStatus playerStatus = null;
  private WebsocketClient currentPlayer = null;
  private final Map<WebSocketSession, Instant> lastPong = new ConcurrentHashMap<>();
  private static final Duration PONG_TIMEOUT = Duration.ofSeconds(35);

  public WebSocketSessionManager(
      EpisodeRepository episodeRepository, PlatformTransactionManager transactionManager) {
    objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
    objectMapper.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
    this.episodeRepository = episodeRepository;
    this.transactionManager = transactionManager;
  }

  public void register(WebSocketSession session) {
    sessions.put(session, new WebsocketClient(null, null));
    log.info("{} websocket sessions", sessions.size());
  }

  public void remove(WebSocketSession session) {
    try {
      cleanupSession(session);
      log.info("{} websocket sessions", sessions.size());
      pingSessions();
    } catch (IOException e) {
      log.error("Couldn't clean session", e);
    }
  }

  private ClientList getClientList() {
    return new ClientList(
        this.currentPlayer,
        sessions.values().stream()
            .filter(websocketClient -> websocketClient.id() != null)
            .toList());
  }

  @Scheduled(cron = "0,30 * * * * *")
  public void pingSessions() {

    var textMessage = new WebSocketMessage<>(WebSocketMessage.Type.clientList, getClientList());

    sessions
        .keySet()
        .forEach(
            s -> {
              try {
                sendMessage(s, objectMapper.writeValueAsString(textMessage));
              } catch (JsonProcessingException e) {
                log.error("Couldn't serialize object", e);
              }
            });
  }

  public void testSessionAndCleanIfNeeded(WebSocketSession s) {
    Instant now = Instant.now();
    try {
      Instant last = lastPong.getOrDefault(s, Instant.EPOCH);
      if (Duration.between(last, now).compareTo(PONG_TIMEOUT) > 0) {
        log.info("Did not receive pong in time, cleaning up");
        try {
          s.close(CloseStatus.SESSION_NOT_RELIABLE);
        } catch (IOException e) {
          // already dead
        } finally {
          cleanupSession(s);
        }
      } else {
        // otherwise, we try to send a message and see if it still responds
        s.sendMessage(new TextMessage("ping"));
      }

    } catch (Exception e) {
      log.warn("Failed to communicate with client, might be disconnected");
      try {
        s.close(CloseStatus.GOING_AWAY);
      } catch (Exception ex) {
        log.info("Couldn't close session properly, most likely gone");
      }
      try {
        cleanupSession(s);
      } catch (IOException ex) {
        log.error("Failed to cleanup session", ex);
      }
    }
  }

  @Scheduled(cron = "15,45 * * * * *")
  public void cleanTimedOutSessions() {
    for (WebSocketSession webSocketSession : sessions.keySet()) {
      testSessionAndCleanIfNeeded(webSocketSession);
    }

    if (currentPlayer != null) {
      var player = getCurrentPlayer();
      player.ifPresent(this::testSessionAndCleanIfNeeded);

      // we can't find a session of the current player, yet it exists, we clean stuff up, client
      // might have been disconnected
      if (player.isEmpty()) {
        currentPlayer = null;
      }
    }
  }

  public <T> void sendToUsers(T content) {
    WebSocketMessage<T> message = new WebSocketMessage<>();
    message.setType(WebSocketMessage.Type.getFromClass(content.getClass()));
    message.setMessage(content);

    for (WebSocketSession session : sessions.keySet()) {
      if (session != null && session.isOpen()) {
        try {
          sendMessage(session, objectMapper.writeValueAsString(message));
        } catch (IOException e) {
          log.error("Error sending message:", e);
        }
      }
    }
  }

  public void handleMessage(WebSocketSession session, TextMessage message) {
    try {
      var parsed = objectMapper.readValue(message.getPayload(), WebSocketMessage.class);

      log.info(
          "Received message of type: {} from {}",
          parsed.getType(),
          getClientForSession(session).map(WebsocketClient::name).orElse("unknown"));

      switch (parsed.getType()) {
        case playerInfo ->
            handlePlayerInfo(
                session, objectMapper.convertValue(parsed.getMessage(), WebsocketClient.class));
        case getPlayerStatus -> sendMessage(session, getCurrentPlayerStatus());
        case playerStatus ->
            handlePlayerStatus(
                session, objectMapper.convertValue(parsed.getMessage(), PlayerStatus.class));
        case remoteCommand -> handleRemoteCommand(parsed);
        case transferPlayback ->
            handlePlaybackTransfer(
                objectMapper.convertValue(parsed.getMessage(), TransferPlayback.class));
        case pong ->
            handlePong(session, objectMapper.convertValue(parsed.getMessage(), PlayerStatus.class));
      }
    } catch (Exception e) {
      log.error("Couldn't parse websocket message", e);
    }
  }

  private void handlePong(WebSocketSession session, PlayerStatus status) {
    if (sessions.containsKey(session)) {
      lastPong.put(session, Instant.now());
      boolean isCurrentPlayer =
          currentPlayer != null && sessions.get(session).id().equalsIgnoreCase(currentPlayer.id());
      if (isCurrentPlayer && status.episode() == null) {
        log.debug(
            "Current player is not playing stuff, there is discrepancy, clearing current player");
        currentPlayer = null;
        pingSessions();
      }
    }
  }

  /**
   * We send the same message to both the current player and the new one the new player will have to
   * stop it's current playback while the new one will have to take over
   *
   * @param transfer the playback transfer data
   * @throws IOException if anything goes wrong during the transfer
   */
  private void handlePlaybackTransfer(TransferPlayback transfer) throws IOException {
    WebSocketMessage<TransferPlayback> message =
        new WebSocketMessage<>(WebSocketMessage.Type.transferPlayback, transfer);
    var textMessage = new TextMessage(objectMapper.writeValueAsString(message));

    WebSocketSession target = null;
    for (Map.Entry<WebSocketSession, WebsocketClient> entry : sessions.entrySet()) {
      WebSocketSession key = entry.getKey();
      WebsocketClient websocketClient = entry.getValue();
      if (websocketClient.id() == null) {
        continue;
      }

      if (websocketClient.id().equalsIgnoreCase(transfer.playerId())) {
        target = key;
        break;
      }
    }

    Optional<WebSocketSession> currentPlayerOpt = getCurrentPlayer();
    if (target == null || currentPlayerOpt.isEmpty()) {
      return;
    }

    var currentPlayer = currentPlayerOpt.get();
    sendMessage(currentPlayer, textMessage);
    sendMessage(target, textMessage);
  }

  private void sendMessage(
      WebSocketSession session, org.springframework.web.socket.WebSocketMessage<?> message) {
    try {
      session.sendMessage(message);
    } catch (Exception e) {
      log.warn("Failed to communicate with client, might be disconnected");
      testSessionAndCleanIfNeeded(session);
    }
  }

  private void sendMessage(WebSocketSession session, String message) {
    sendMessage(session, new TextMessage(message));
  }

  private void handlePlayerInfo(WebSocketSession session, WebsocketClient client) {
    sessions.put(session, client);
    pingSessions();
  }

  private void handleRemoteCommand(WebSocketMessage<?> remoteCommand) {
    getCurrentPlayer()
        .ifPresent(
            s -> {
              try {
                sendMessage(s, new TextMessage(objectMapper.writeValueAsString(remoteCommand)));
              } catch (IOException e) {
                throw new RuntimeException(e);
              }
            });
  }

  private Optional<WebSocketSession> getCurrentPlayer() {
    return getSessionForClient(currentPlayer);
  }

  private Optional<WebSocketSession> getSessionForClient(WebsocketClient client) {
    if (client == null) {
      return Optional.empty();
    }

    for (Map.Entry<WebSocketSession, WebsocketClient> entry : sessions.entrySet()) {
      WebSocketSession webSocketSession = entry.getKey();
      WebsocketClient websocketClient = entry.getValue();
      if (websocketClient.id() == null) {
        continue;
      }

      if (websocketClient.id().equalsIgnoreCase(client.id())) {
        return Optional.ofNullable(webSocketSession);
      }
    }

    return Optional.empty();
  }

  private Optional<WebsocketClient> getClientForSession(WebSocketSession session) {
    return Optional.ofNullable(sessions.get(session));
  }

  private void cleanupSession(WebSocketSession session) throws IOException {
    var remoteSession = sessions.get(session);
    if (remoteSession != null) {

      WebSocketMessage<PlayerStatus> message = null;

      if (remoteSession != null
          && currentPlayer != null
          && remoteSession.id().equalsIgnoreCase(currentPlayer.id())) {
        playerStatus = null;
        currentPlayer = null;

        message = new WebSocketMessage<>(WebSocketMessage.Type.playerStatus, null);
      }

      sessions.remove(session);

      if (message != null) {
        var textMessage = new TextMessage(objectMapper.writeValueAsString(message));
        for (WebSocketSession webSocketSession : sessions.keySet()) {
          sendMessage(webSocketSession, textMessage);
        }
      }
    }
  }

  /**
   * A client starts playing or updates its playback status will be broadcasted to all other
   * connected clients
   */
  private void handlePlayerStatus(WebSocketSession session, PlayerStatus newPlayerStatus)
      throws IOException {
    boolean broadcastClients = false;

    String newPlayerClient =
        Optional.ofNullable(sessions.get(session)).map(WebsocketClient::id).orElse("no-new-player");
    String currentPlayerClient =
        Optional.ofNullable(this.currentPlayer)
            .map(WebsocketClient::id)
            .orElse("no-current-player");
    if (newPlayerStatus == null
        || (newPlayerStatus.broadcast()
            && !newPlayerClient.equalsIgnoreCase(currentPlayerClient))) {
      broadcastClients = true;
    }
    // we update the current status
    if (newPlayerStatus == null || newPlayerStatus.episode() == null) {
      // playback stopped
      this.playerStatus = null;
      this.currentPlayer = null;
    } else if (newPlayerStatus.episode().getId() != null) {
      // only if it's meant to be broadcasted, we save it as current player.
      if (newPlayerStatus.broadcast()) {
        this.playerStatus =
            new PlayerStatus(
                newPlayerStatus.episode(),
                newPlayerStatus.position(),
                newPlayerStatus.duration(),
                newPlayerStatus.playing(),
                newPlayerStatus.speed(),
                newPlayerStatus.volume(),
                true);

        this.currentPlayer = getClientForSession(session).orElse(null);
      }
      TransactionHelper.doInNewTransaction(
          transactionManager,
          false,
          () ->
              episodeRepository
                  .findById(newPlayerStatus.episode().getId())
                  .ifPresent(
                      episode -> {
                        log.info(
                            "Saving progress for episode {} position: {}s",
                            episode.getTitle(),
                            newPlayerStatus.position());
                        episode.setProgress(newPlayerStatus.position());
                        episodeRepository.save(episode);
                      }));
    }

    if (broadcastClients) {
      pingSessions();
    }

    if (this.playerStatus == null || (newPlayerStatus != null && newPlayerStatus.broadcast())) {
      WebSocketMessage<PlayerStatus> message =
          new WebSocketMessage<>(WebSocketMessage.Type.playerStatus, this.playerStatus);

      for (Map.Entry<WebSocketSession, WebsocketClient> entry : sessions.entrySet()) {
        WebSocketSession webSocketSession = entry.getKey();
        WebsocketClient websocketClient = entry.getValue();
        // we don't broadcast to empty clients and we don't broadcast to the session that sent the
        // broadcast
        if (websocketClient == null
            || webSocketSession == null
            || webSocketSession == session
            || websocketClient.id() == null) {
          if (websocketClient != null) {
            log.info("Skipping sending to {}", websocketClient.name());
          }
          continue;
        }

        sendMessage(webSocketSession, new TextMessage(objectMapper.writeValueAsString(message)));
      }
    }
  }

  private TextMessage getCurrentPlayerStatus() throws JsonProcessingException {
    WebSocketMessage<PlayerStatus> status =
        new WebSocketMessage<>(WebSocketMessage.Type.playerStatus, playerStatus);

    try {
      return new TextMessage(objectMapper.writeValueAsBytes(status));
    } catch (JsonProcessingException e) {
      log.error("Couldn't format player status", e);
      throw e;
    }
  }
}
