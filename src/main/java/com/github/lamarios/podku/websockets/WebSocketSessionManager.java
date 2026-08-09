package com.github.lamarios.podku.websockets;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.github.lamarios.podku.episodes.EpisodeRepository;
import com.github.lamarios.podku.utils.TransactionHelper;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;


@Component
public class WebSocketSessionManager {
    private final Logger log = LogManager.getLogger();
    private final Map<WebSocketSession, WebsocketClient> sessions = new ConcurrentHashMap<>();
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final EpisodeRepository episodeRepository;
    private final PlatformTransactionManager transactionManager;
    private PlayerStatus playerStatus = null;

    public WebSocketSessionManager(EpisodeRepository episodeRepository, PlatformTransactionManager transactionManager) {
        objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
        this.episodeRepository = episodeRepository;
        this.transactionManager = transactionManager;
    }

    public void register(WebSocketSession session) {
        sessions.put(session, new WebsocketClient(null,null));
        log.info("{} websocket sessions", sessions.size());
    }

    public void remove(WebSocketSession session) {
        try {
            cleanupSession(session);
            log.info("{} websocket sessions", sessions.size());
            broadcastClients();
        } catch (IOException e) {
            log.error("Couldn't clean session", e);
        }
    }

    private ClientList  getClientList(){
        return new ClientList(sessions.values().stream().filter(websocketClient -> websocketClient.id()!=null).toList());
    }

    @Scheduled(cron = "0 * * * * *")
    public void testingSessions() {
        List<WebSocketSession> toRemove = new ArrayList<>();

        var textMessage = new WebSocketMessage<ClientList>(WebSocketMessage.Type.clientList, getClientList());

        sessions.keySet().forEach(s -> {
            try {
                // we broadcast the clients as a test
                s.sendMessage(new TextMessage(objectMapper.writeValueAsString(textMessage)));
            } catch (Exception e) {
                log.warn("Failed to communicate with client, might be disconnected");
                try {
                    s.close(CloseStatus.GOING_AWAY);
                } catch (Exception ex) {
                    log.info("Couldn't close session properly, most likely gone");
                }

                toRemove.add(s);
            }
        });

        log.info("Removed {} inactive sessions", toRemove.size());

        for (WebSocketSession webSocketSession : toRemove) {
            try {
                cleanupSession(webSocketSession);
            } catch (IOException e) {
                log.error("Couldn't clean up session", e);
            }
        }
    }

    public <T> void sendToUsers(T content) {
        WebSocketMessage<T> message = new WebSocketMessage<T>();
        message.setType(WebSocketMessage.Type.getFromClass(content.getClass()));
        message.setMessage(content);

        for (WebSocketSession session : sessions.keySet()) {
            if (session != null && session.isOpen()) {
                try {
                    session.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));
                } catch (IOException e) {
                    log.error("Error sending message:", e);
                }
            }
        }
    }

    public void handleMessage(WebSocketSession session, TextMessage message) {
        try {
            WebSocketMessage parsed = objectMapper.readValue(message.getPayload(), WebSocketMessage.class);

            log.info("Received message of type: {}", parsed.getType());

            switch (parsed.getType()) {
                case playerInfo ->
                        handlePlayerInfo(session, objectMapper.convertValue(parsed.getMessage(), WebsocketClient.class));
                case getPlayerStatus -> session.sendMessage(getCurrentPlayerStatus());
                case playerStatus ->
                        handlePlayerStatus(session, objectMapper.convertValue(parsed.getMessage(), PlayerStatus.class));
                case remoteCommand -> handleRemoteCommand(parsed);
                case transferPlayback ->
                        handlePlaybackTransfer(objectMapper.convertValue(parsed.getMessage(), TransferPlayback.class));
            }

        } catch (Exception e) {
            log.error("Couldn't parse websocket message", e);
        }
    }

    /**
     * We send the same message to both the current player and the new one
     * the new player will have to stop it's current playback while the new one will have to take over
     *
     * @param transfer
     * @throws IOException
     */
    private void handlePlaybackTransfer(TransferPlayback transfer) throws IOException {
        WebSocketMessage<TransferPlayback> message = new WebSocketMessage<>(WebSocketMessage.Type.transferPlayback, transfer);
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
        currentPlayer.sendMessage(textMessage);
        target.sendMessage(textMessage);
    }

    private void broadcastClients() {
        // we inform all clients of existing users
        sendToUsers(getClientList());
    }

    private void handlePlayerInfo(WebSocketSession session, WebsocketClient client) {
        sessions.put(session, client);
        broadcastClients();
    }

    private void handleRemoteCommand(WebSocketMessage remoteCommand) {
        getCurrentPlayer().ifPresent(s -> {
            try {
                s.sendMessage(new TextMessage(objectMapper.writeValueAsString(remoteCommand)));
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
    }

    private Optional<WebSocketSession> getCurrentPlayer() {
        for (Map.Entry<WebSocketSession, WebsocketClient> entry : sessions.entrySet()) {
            WebSocketSession webSocketSession = entry.getKey();
            WebsocketClient websocketClient = entry.getValue();
            if (websocketClient.id() == null) {
                continue;
            }

            if (websocketClient.id().equalsIgnoreCase(playerStatus.client().id())) {
                return Optional.ofNullable(webSocketSession);
            }

        }

        return Optional.empty();
    }

    private void cleanupSession(WebSocketSession session) throws IOException {

        var remoteSession = sessions.get(session);

        WebSocketMessage<PlayerStatus> message = null;

        if (remoteSession != null && playerStatus != null && remoteSession.id().equalsIgnoreCase(playerStatus.client().id())) {
            playerStatus = null;


            message = new WebSocketMessage<>(WebSocketMessage.Type.playerStatus, null);

        }


        sessions.remove(session);

        if (message != null) {
            var textMessage = new TextMessage(objectMapper.writeValueAsString(message));
            for (WebSocketSession webSocketSession : sessions.keySet()) {
                webSocketSession.sendMessage(textMessage);
            }
        }

    }


    /**
     * A client starts playing or updates its playback status
     * will be broadcasted to all other connected clients
     */
    private void handlePlayerStatus(WebSocketSession session, PlayerStatus playerStatus) throws IOException {
        // we update the current status
        this.playerStatus = new PlayerStatus(sessions.get(session), playerStatus.episode(), playerStatus.position(), playerStatus.duration(), playerStatus.playing(), playerStatus.speed());

        if (playerStatus.episode() == null) {
            // playback stopped
            this.playerStatus = null;
        } else if (playerStatus.episode().getId() != null) {
            TransactionHelper.doInNewTransaction(transactionManager, false, () -> {
                episodeRepository.findById(playerStatus.episode().getId()).ifPresent(episode -> {
                    episode.setProgress(playerStatus.position());
                    episodeRepository.save(episode);
                });
            });
        }

        WebSocketMessage<PlayerStatus> message = new WebSocketMessage<>(WebSocketMessage.Type.playerStatus, this.playerStatus);

        for (Map.Entry<WebSocketSession, WebsocketClient> entry : sessions.entrySet()) {
            WebSocketSession webSocketSession = entry.getKey();
            WebsocketClient websocketClient = entry.getValue();
            if (websocketClient.id() == null
//                    || (this.playerStatus != null && websocketClient.id().equalsIgnoreCase(this.playerStatus.client().id()))
            ) {
                continue;
            }

            webSocketSession.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));

        }
    }

    private TextMessage getCurrentPlayerStatus() throws JsonProcessingException {
        WebSocketMessage<PlayerStatus> status = new WebSocketMessage<>(WebSocketMessage.Type.playerStatus, playerStatus);


        try {
            return new TextMessage(objectMapper.writeValueAsBytes(status));
        } catch (JsonProcessingException e) {
            log.error("Couldn't format player status", e);
            throw e;
        }
    }
}
