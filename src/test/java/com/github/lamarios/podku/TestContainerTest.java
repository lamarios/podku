package com.github.lamarios.podku;

import com.github.lamarios.podku.podcasts.PodcastRepository;
import org.junit.jupiter.api.AfterEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Testcontainers;

@SuppressWarnings("SpringBootApplicationProperties")
@SpringBootTest(
    classes = Application.class,
    properties = {
      "spring.main.allow-bean-definition-overriding=true",
      "SALT=somesalktfsdfasfsdfdsfsd"
    },
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@Testcontainers
public abstract class TestContainerTest {
  private static final PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:18");

  static {
    postgres.start();
  }

  @Autowired private PodcastRepository podcastRepository;

  @DynamicPropertySource
  static void configureSQLContainer(DynamicPropertyRegistry registry) {
    registry.add("spring.datasource.url", postgres::getJdbcUrl);
    registry.add("spring.datasource.username", postgres::getUsername);
    registry.add("spring.datasource.password", postgres::getPassword);
    registry.add("spring.flyway.url", postgres::getJdbcUrl);
    registry.add("spring.flyway.user", postgres::getUsername);
    registry.add("spring.flyway.password", postgres::getPassword);
  }

  @AfterEach
  public void cleaningDB() {
    podcastRepository.deleteAll();
  }
}
