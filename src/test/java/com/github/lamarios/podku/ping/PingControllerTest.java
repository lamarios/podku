package com.github.lamarios.podku.ping;

import com.github.lamarios.podku.TestContainerTest;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

public class PingControllerTest extends TestContainerTest {
  @Autowired private PingController pingController;

  @Test
  public void testPing() {
    Assertions.assertEquals("pong", pingController.ping());
  }
}
