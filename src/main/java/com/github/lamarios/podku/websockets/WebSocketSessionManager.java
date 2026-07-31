package com.github.lamarios.podku.websockets;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class WebSocketSessionManager {
    private final static Logger log = LogManager.getLogger();
    private static final List<WebSocketSession> sessions = new ArrayList<>();
    private static final ObjectMapper objectMapper = new ObjectMapper();

    static {
        objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
    }

    public static void register(WebSocketSession session) {
        sessions.add(session);
        log.info("{} websocket sessions", sessions.size());
    }

    public static void remove(WebSocketSession session) {
        sessions.remove(session);
        log.info("{} websocket sessions", sessions.size());
    }

    public static <T> void sendToUsers(T content) {
        WebSocketMessage<T> message = new WebSocketMessage<T>();
        message.setType(WebSocketMessage.Type.getFromClass(content.getClass()));
        message.setMessage(content);

        for (WebSocketSession session : sessions) {
            if (session != null && session.isOpen()) {
                try {
                    session.sendMessage(new TextMessage(objectMapper.writeValueAsString(message)));
                } catch (IOException e) {
                    log.error("Error sending message:", e);
                }
            }
        }
    }
}
