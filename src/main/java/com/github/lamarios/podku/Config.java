/* (C)2026 */
package com.github.lamarios.podku;

import javax.sql.DataSource;
import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Application-wide configuration: CORS rules for the REST endpoints and the Flyway migration setup.
 */
@Configuration
public class Config {
  /**
   * Registers the CORS policy: the health endpoint is reachable with GET/OPTIONS only, while every
   * other path accepts the full set of methods used by the frontends.
   */
  @Bean
  public WebMvcConfigurer corsConfigurer() {
    return new WebMvcConfigurer() {
      @Override
      public void addCorsMappings(CorsRegistry registry) {
        registry
            .addMapping("/actuator/health")
            .allowedOriginPatterns("*")
            .allowedMethods("GET", "OPTIONS");

        registry
            // apply to all endpoints
            .addMapping("/**")
            // frontend URLs
            .allowedOriginPatterns("*")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD")
            .allowedHeaders("*")
            .allowCredentials(true);
      }
    };
  }

  /**
   * Creates the Flyway instance and runs pending migrations immediately so the schema is ready
   * before any repository is used.
   *
   * @param dataSource the JDBC data source migrations apply to
   * @param locations Flyway migration script locations (classpath paths)
   * @param baselineOnMigrate whether to baseline an existing database before migrating
   * @return the configured {@link Flyway} instance, already migrated
   */
  @Bean(name = "flyway")
  public Flyway flyway(
      DataSource dataSource,
      @Value("${spring.flyway.locations}") String locations,
      @Value("${spring.flyway.baseline-on-migrate:false}") boolean baselineOnMigrate) {
    Flyway flyway =
        Flyway.configure()
            .dataSource(dataSource)
            .locations(locations)
            .baselineOnMigrate(baselineOnMigrate)
            .load();
    // Force migration to run
    flyway.migrate();
    return flyway;
  }
}
