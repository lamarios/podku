package com.github.lamarios.podku.staticContent;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.github.lamarios.podku.TestContainerTest;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

public class StaticContentControllerTest extends TestContainerTest {

  @Autowired private StaticContentController staticContentController;

  @Test
  public void testServeIndex() {
    assertEquals("index.html", staticContentController.serveIndex());
  }
}
