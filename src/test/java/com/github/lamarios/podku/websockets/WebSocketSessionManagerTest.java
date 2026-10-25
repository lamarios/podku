package com.github.lamarios.podku.websockets;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import com.github.lamarios.podku.TestContainerTest;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

public class WebSocketSessionManagerTest extends TestContainerTest {
  @Autowired private WebSocketSessionManager webSocketSessionManager;

  @SuppressWarnings("unchecked")
  private Map<WebSocketSession, ?> field(String name) {
    return (Map<WebSocketSession, ?>) ReflectionTestUtils.getField(webSocketSessionManager, name);
  }

  @Test
  public void testRemovedSessionIsForgotten() {
    WebSocketSession session = mock(WebSocketSession.class);
    when(session.isOpen()).thenReturn(true);

    webSocketSessionManager.register(session);
    webSocketSessionManager.handleMessage(
        session, new TextMessage("{\"type\":\"pong\",\"message\":{\"position\":0}}"));
    assertTrue(field("lastPong").containsKey(session), "pong is tracked while connected");

    webSocketSessionManager.remove(session);

    assertFalse(field("sessions").containsKey(session));
    assertFalse(field("lastPong").containsKey(session), "closed sessions must not be retained");
  }
}
