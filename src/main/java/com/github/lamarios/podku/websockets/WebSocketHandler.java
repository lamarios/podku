/* (C)2026 */
package com.github.lamarios.podku.websockets;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class WebSocketHandler extends TextWebSocketHandler {
    private static final Logger log = LogManager.getLogger();
    private final WebSocketSessionManager webSocketSessionManager;

    @Autowired
    public WebSocketHandler(WebSocketSessionManager webSocketSessionManager) {
        this.webSocketSessionManager = webSocketSessionManager;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        webSocketSessionManager.register(session);
        log.info("New websocket session");
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        // If you don’t want client messages, ignore this
        webSocketSessionManager.handleMessage(session, message);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        webSocketSessionManager.remove(session);
        log.info("User disconnected");
    }
}
