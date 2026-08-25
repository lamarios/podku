/* (C)2026 */
package com.github.lamarios.podku;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Entry point of the Podku backend. Boots the Spring application, exposes the OpenAPI specification
 * and enables scheduled tasks.
 */
@SpringBootApplication
@OpenAPIDefinition(info = @Info(title = "Podku API", version = "1.0", description = "Podku API"))
@EnableScheduling
public class Application {
  /**
   * Starts the Spring application.
   *
   * @param args command line arguments forwarded to Spring Boot
   */
  public static void main(String[] args) {
    SpringApplication.run(Application.class, args);
  }
}
