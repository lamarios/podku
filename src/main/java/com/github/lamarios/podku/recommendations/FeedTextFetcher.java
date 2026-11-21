/* (C)2026 */
package com.github.lamarios.podku.recommendations;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Optional;
import java.util.Set;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamConstants;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

/**
 * Reads the text describing a podcast from its RSS feed: the channel description and the titles and
 * descriptions of its latest items.
 *
 * <p>The feed is streamed and the download stops after the requested number of items, so this is
 * much cheaper than parsing the whole feed with {@link
 * com.github.lamarios.podku.podcasts.PodcastParser} (some feeds are several megabytes).
 */
@Service
public class FeedTextFetcher {
  private static final Logger log = LogManager.getLogger();
  private static final Duration CONNECT_TIMEOUT = Duration.ofSeconds(5);
  private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(10);

  /** Postgres refuses to build a tsvector from too long a text. */
  static final int MAX_TEXT_LENGTH = 100_000;

  private static final HttpClient HTTP_CLIENT =
      HttpClient.newBuilder()
          .connectTimeout(CONNECT_TIMEOUT)
          .followRedirects(HttpClient.Redirect.NORMAL)
          .build();

  private static final XMLInputFactory XML_INPUT_FACTORY = createXmlInputFactory();

  /**
   * Fetches a feed and extracts its descriptive text.
   *
   * @param feedUrl the RSS feed URL
   * @param maxItems maximum number of items to read
   * @return the text, or empty if the feed couldn't be fetched or parsed
   */
  public Optional<String> fetchText(String feedUrl, int maxItems) {
    try {
      HttpRequest request =
          HttpRequest.newBuilder(URI.create(feedUrl)).timeout(REQUEST_TIMEOUT).GET().build();
      HttpResponse<InputStream> response =
          HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofInputStream());
      try (InputStream body = response.body()) {
        if (response.statusCode() != 200) {
          log.debug("Feed {} answered with status {}", feedUrl, response.statusCode());
          return Optional.empty();
        }
        String text = extractText(body, maxItems);
        return text.isBlank() ? Optional.empty() : Optional.of(text);
      }
    } catch (IOException | XMLStreamException | IllegalArgumentException e) {
      log.debug("Could not read feed {}: {}", feedUrl, e.getMessage());
      return Optional.empty();
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
      return Optional.empty();
    }
  }

  /**
   * Extracts the channel title and description and the latest items' titles and descriptions from
   * an RSS stream. Falls back to {@code itunes:summary} when there is no description.
   *
   * <p>Invalid XML (unknown entities are common in feeds) ends the extraction, the text read so far
   * is kept.
   *
   * @param in the RSS XML stream
   * @param maxItems maximum number of items to read
   * @return the extracted text, one element per line
   * @throws XMLStreamException if the stream isn't XML at all
   */
  static String extractText(InputStream in, int maxItems) throws XMLStreamException {
    XMLStreamReader reader = XML_INPUT_FACTORY.createXMLStreamReader(in);
    TextCollector collector = new TextCollector();
    Deque<String> path = new ArrayDeque<>();
    int items = 0;

    try {
      while (reader.hasNext() && items < maxItems && collector.length() < MAX_TEXT_LENGTH) {
        switch (reader.next()) {
          case XMLStreamConstants.START_ELEMENT -> {
            String name = reader.getLocalName();
            String parent = path.peek();
            path.push(name);
            if (name.equals("item")) {
              // the channel's description comes before its first item
              collector.flushDescription();
            } else if (("channel".equals(parent) || "item".equals(parent))
                && TEXT_ELEMENTS.contains(name)) {
              collector.start(name);
            }
          }
          case XMLStreamConstants.CHARACTERS, XMLStreamConstants.CDATA ->
              collector.characters(reader.getText());
          case XMLStreamConstants.END_ELEMENT -> {
            String name = path.pop();
            collector.end(name);
            if (name.equals("item")) {
              collector.flushDescription();
              items++;
            } else if (name.equals("channel")) {
              collector.flushDescription();
            }
          }
          default -> {}
        }
      }
    } catch (XMLStreamException | RuntimeException e) {
      // woodstox reports some errors (e.g. undeclared entities) with runtime exceptions
      if (collector.length() == 0) {
        throw new XMLStreamException(e.getMessage(), e);
      }
      log.debug("Invalid feed XML, keeping the text read so far: {}", e.getMessage());
    } finally {
      reader.close();
    }

    String text = collector.text();
    return text.length() > MAX_TEXT_LENGTH ? text.substring(0, MAX_TEXT_LENGTH) : text;
  }

  private static final Set<String> TEXT_ELEMENTS = Set.of("title", "description", "summary");

  /**
   * Accumulates the text of the channel and its items, keeping either the description or the {@code
   * itunes:summary} of each, not both.
   */
  private static final class TextCollector {
    private final StringBuilder out = new StringBuilder();
    private StringBuilder current;
    private String currentName;
    private String description;
    private String summary;

    /**
     * Starts collecting the text of an element.
     *
     * @param name the element's local name
     */
    void start(String name) {
      current = new StringBuilder();
      currentName = name;
    }

    /**
     * Collects text, if an element is being collected.
     *
     * @param text the characters
     */
    void characters(String text) {
      if (current != null) {
        current.append(text);
      }
    }

    /**
     * Ends the element being collected, if it's the given one.
     *
     * @param name the local name of the element that ends
     */
    void end(String name) {
      if (current == null || !name.equals(currentName)) {
        return;
      }
      String text = current.toString().strip();
      current = null;
      switch (name) {
        case "description" -> description = text;
        case "summary" -> summary = text;
        default -> append(out, text);
      }
    }

    /** Appends the pending description (or summary when there is none) of the channel/item. */
    void flushDescription() {
      append(out, description != null && !description.isBlank() ? description : summary);
      description = null;
      summary = null;
    }

    /**
     * Length of the text collected so far.
     *
     * @return the length
     */
    int length() {
      return out.length();
    }

    /**
     * The text collected so far.
     *
     * @return the text
     */
    String text() {
      return out.toString();
    }
  }

  /**
   * Appends a non-blank text as a new line.
   *
   * @param out the buffer
   * @param text the text, may be null
   */
  private static void append(StringBuilder out, String text) {
    if (text != null && !text.isBlank()) {
      out.append(text).append('\n');
    }
  }

  /**
   * Creates a StAX factory that doesn't resolve DTDs or external entities, feeds being untrusted.
   *
   * @return the factory
   */
  private static XMLInputFactory createXmlInputFactory() {
    XMLInputFactory factory = XMLInputFactory.newInstance();
    factory.setProperty(XMLInputFactory.SUPPORT_DTD, false);
    factory.setProperty(XMLInputFactory.IS_SUPPORTING_EXTERNAL_ENTITIES, false);
    factory.setProperty(XMLInputFactory.IS_COALESCING, true);
    return factory;
  }
}
