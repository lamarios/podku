/* (C)2026 */
package com.github.lamarios.podku;

import com.github.lamarios.podku.episodes.Chapters;
import com.github.lamarios.podku.search.SearchResult;
import com.github.lamarios.podku.utils.BookmarkTopicResponse;
import com.github.lamarios.podku.websockets.ClientList;
import com.github.lamarios.podku.websockets.PlaybackProgress;
import com.github.lamarios.podku.websockets.PlayerStatus;
import com.github.lamarios.podku.websockets.RemoteCommand;
import com.github.lamarios.podku.websockets.TransferPlayback;
import com.github.lamarios.podku.websockets.WebSocketMessage;
import com.github.lamarios.podku.websockets.WebsocketClient;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.List;
import org.springframework.aot.hint.MemberCategory;
import org.springframework.aot.hint.RuntimeHints;
import org.springframework.aot.hint.RuntimeHintsRegistrar;
import org.springframework.aot.hint.TypeReference;
import org.springframework.aot.hint.annotation.RegisterReflectionForBinding;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportRuntimeHints;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

/**
 * GraalVM native image hints for what Spring AOT can't infer on its own: classes that are
 * (de)serialized with our own Jackson / Unirest / OpenAI mappers instead of through controller
 * signatures, and third party reflection that isn't covered by the libraries' own metadata.
 *
 * <p>The AWT/ImageIO JNI registrations (color extraction) and the kxml2 XmlPull provider (OPML) are
 * in {@code
 * META-INF/native-image/com.github.lamarios.podku/podku-manual/reachability-metadata.json},
 * recorded with the native-image tracing agent (not in .../podku/ as Spring AOT overwrites that
 * one).
 */
@Configuration(proxyBeanMethods = false)
@ImportRuntimeHints(NativeHints.Registrar.class)
@RegisterReflectionForBinding({
  // websocket payloads, mapped manually in WebSocketSessionManager
  WebSocketMessage.class,
  PlayerStatus.class,
  RemoteCommand.class,
  WebsocketClient.class,
  ClientList.class,
  TransferPlayback.class,
  PlaybackProgress.class,
  // Unirest asObject()
  Chapters.class,
  // iTunes search results, converted from JsonNode
  SearchResult.class,
  // OpenAI structured output, the json schema is derived from the class
  BookmarkTopicResponse.class
})
public class NativeHints {

  static class Registrar implements RuntimeHintsRegistrar {
    /**
     * Registers reflection hints not covered by the third party libraries' own metadata.
     *
     * @param hints the hints to contribute to
     * @param classLoader the class loader in use
     */
    @Override
    public void registerHints(RuntimeHints hints, ClassLoader classLoader) {
      // Tomcat sets/reads connector properties ("bindOnInit", "SSLEnabled", ...) reflectively
      // through IntrospectionUtils, its own native metadata only covers a few of those methods
      for (String type :
          List.of(
              "org.apache.coyote.AbstractProtocol",
              "org.apache.coyote.http11.AbstractHttp11Protocol",
              "org.apache.tomcat.util.net.AbstractEndpoint")) {
        hints
            .reflection()
            .registerType(TypeReference.of(type), MemberCategory.INVOKE_PUBLIC_METHODS);
      }

      // kotlin-reflect (pulled in by openai-java, used by springdoc) looks up record accessors
      // reflectively to stay compatible with older JDKs
      hints
          .reflection()
          .registerType(
              java.lang.reflect.RecordComponent.class, MemberCategory.INVOKE_PUBLIC_METHODS);

      // micrometer's tomcat metrics start the platform MBean server, which maps these to open
      // types reflectively (e.g. MemoryUsage.from(CompositeData)) and fails startup without them
      for (String type :
          List.of(
              "java.lang.management.MemoryUsage",
              "java.lang.management.MemoryNotificationInfo",
              "java.lang.management.ThreadInfo",
              "java.lang.management.LockInfo",
              "java.lang.management.MonitorInfo",
              "com.sun.management.GcInfo",
              "com.sun.management.VMOption",
              "com.sun.management.GarbageCollectionNotificationInfo")) {
        hints
            .reflection()
            .registerType(TypeReference.of(type), MemberCategory.INVOKE_PUBLIC_METHODS);
      }

      // openai-java models are deserialized by Jackson through private @JsonCreator constructors
      // and a private @JsonAnySetter (putAdditionalProperty) for unknown fields such as
      // "reasoning_content" that local servers return. Only register the packages we use, the
      // whole SDK is ~20k classes.
      var resolver = new PathMatchingResourcePatternResolver(classLoader);
      for (String pkg :
          List.of(
              "com/openai/models",
              "com/openai/models/chat/completions",
              "com/openai/models/completions",
              "com/openai/models/models")) {
        try {
          for (Resource resource : resolver.getResources("classpath*:" + pkg + "/*.class")) {
            String className =
                pkg.replace('/', '.')
                    + "."
                    + resource.getFilename().substring(0, resource.getFilename().length() - 6);
            hints
                .reflection()
                .registerType(
                    TypeReference.of(className),
                    MemberCategory.INVOKE_DECLARED_CONSTRUCTORS,
                    MemberCategory.INVOKE_DECLARED_METHODS,
                    MemberCategory.ACCESS_DECLARED_FIELDS);
          }
        } catch (IOException e) {
          throw new UncheckedIOException(e);
        }
      }
    }
  }
}
