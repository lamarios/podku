package com.github.lamarios.podku.mock;

import java.util.ArrayList;
import java.util.List;

/** Builds RSS feeds for tests, to be served with {@link MockFeedController#serve}. */
public final class MockFeeds {
  private MockFeeds() {}

  /**
   * Builds a feed.
   *
   * @param title the channel title
   * @param items the feed items
   * @return the RSS XML
   */
  public static String feed(String title, Item... items) {
    StringBuilder sb = new StringBuilder();
    for (Item item : items) {
      sb.append(item.toXml());
    }
    return """
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0"
             xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
             xmlns:podcast="https://podcastindex.org/namespace/1.0">
          <channel>
            <title>%s</title>
            %s
          </channel>
        </rss>
        """
        .formatted(title, sb);
  }

  /**
   * Starts building an item.
   *
   * @param guid the item guid, or null for a guid-less item
   * @param title the item title, also used to derive the audio URL
   * @return the item builder
   */
  public static Item item(String guid, String title) {
    return new Item(guid, title);
  }

  /** A feed item. */
  public static final class Item {
    private final String guid;
    private final String title;
    private String audioUrl;
    private final List<String> files = new ArrayList<>();
    private final List<String> people = new ArrayList<>();

    private Item(String guid, String title) {
      this.guid = guid;
      this.title = title;
      this.audioUrl = "http://localhost/" + title.replaceAll("\\W", "") + ".mp3";
    }

    /**
     * Sets the enclosure URL.
     *
     * @param url the audio URL
     * @return this
     */
    public Item audio(String url) {
      this.audioUrl = url;
      return this;
    }

    /**
     * Adds a VTT transcript.
     *
     * @param url the transcript URL
     * @param language the transcript language
     * @return this
     */
    public Item transcript(String url, String language) {
      files.add(
          "<podcast:transcript url=\"%s\" type=\"text/vtt\" language=\"%s\"/>"
              .formatted(url, language));
      return this;
    }

    /**
     * Adds a chapters file.
     *
     * @param url the chapters URL
     * @return this
     */
    public Item chapters(String url) {
      files.add("<podcast:chapters url=\"%s\" type=\"application/json+chapters\"/>".formatted(url));
      return this;
    }

    /**
     * Adds a person.
     *
     * @param name the person name
     * @param role the person role
     * @return this
     */
    public Item person(String name, String role) {
      people.add("<podcast:person role=\"%s\">%s</podcast:person>".formatted(role, name));
      return this;
    }

    private String toXml() {
      return """
          <item>
            <title>%s</title>
            %s
            <pubDate>Mon, 01 Jan 2024 12:00:00 GMT</pubDate>
            <enclosure url="%s" length="1" type="audio/mpeg"/>
            %s
            %s
          </item>
          """
          .formatted(
              title,
              guid == null ? "" : "<guid>" + guid + "</guid>",
              audioUrl,
              String.join("", files),
              String.join("", people));
    }
  }
}
