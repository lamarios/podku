package com.github.lamarios.podku;

import com.github.lamarios.podku.bookmarks.BookmarkRepository;
import com.github.lamarios.podku.mock.MockFeedController;
import com.github.lamarios.podku.podcasts.PodcastRepository;
import com.github.lamarios.podku.utils.BackgroundTasks;
import org.junit.jupiter.api.AfterEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Testcontainers;

@SuppressWarnings("SpringBootApplicationProperties")
@SpringBootTest(
    classes = {Application.class, MockFeedController.class},
    properties = {
      "spring.main.allow-bean-definition-overriding=true",
      "SALT=somesalktfsdfasfsdfdsfsd"
    },
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
public abstract class TestContainerTest {
  private static final PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:18");

  static {
    System.setProperty("SALT", "somesalktfsdfasfsdfdsfsd");
    postgres.start();
  }

  @LocalServerPort protected int port;

  @Autowired private PodcastRepository podcastRepository;
  @Autowired private BookmarkRepository bookmarkRepository;

  @DynamicPropertySource
  static void configureSQLContainer(DynamicPropertyRegistry registry) {
    registry.add("spring.datasource.url", postgres::getJdbcUrl);
    registry.add("spring.datasource.username", postgres::getUsername);
    registry.add("spring.datasource.password", postgres::getPassword);
    registry.add("spring.flyway.url", postgres::getJdbcUrl);
    registry.add("spring.flyway.user", postgres::getUsername);
    registry.add("spring.flyway.password", postgres::getPassword);
  }

  protected String getBaseUrl() {
    return "http://localhost:" + port;
  }

  @AfterEach
  public void cleaningDB() throws InterruptedException {
    long timeout = System.currentTimeMillis() + 10000;
    while (BackgroundTasks.getInFlight().get() > 0 && System.currentTimeMillis() < timeout) {
      Thread.sleep(50);
    }
    bookmarkRepository.deleteAll();
    podcastRepository.deleteAll();
  }
}
