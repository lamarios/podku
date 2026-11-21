package com.github.lamarios.podku.recommendations;

import static org.junit.jupiter.api.Assertions.*;

import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import org.junit.jupiter.api.Test;

public class FeedTextFetcherTest {

  private static String extract(String xml, int maxItems) throws Exception {
    return FeedTextFetcher.extractText(
        new ByteArrayInputStream(xml.getBytes(StandardCharsets.UTF_8)), maxItems);
  }

  @Test
  public void testExtractsChannelAndItemText() throws Exception {
    String xml =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
          <channel>
            <title>Rust Weekly</title>
            <image><title>Image title</title></image>
            <description>All about the Rust language</description>
            <itunes:summary>Duplicate summary</itunes:summary>
            <item>
              <title>Borrow checker</title>
              <itunes:summary>Only a summary here</itunes:summary>
            </item>
            <item>
              <title>Async</title>
              <description><![CDATA[<p>Tokio &amp; futures</p>]]></description>
            </item>
            <item>
              <title>Not read</title>
            </item>
          </channel>
        </rss>
        """;

    String text = extract(xml, 2);

    assertEquals(
        "Rust Weekly\nAll about the Rust language\nBorrow checker\nOnly a summary here\n"
            + "Async\n<p>Tokio &amp; futures</p>\n",
        text);
  }

  @Test
  public void testKeepsTextReadBeforeInvalidXml() throws Exception {
    String xml =
        """
        <rss><channel><title>Broken</title><description>Valid part</description>
        <item><title>Bad &nbsp; entity</title></item></channel></rss>
        """;

    String text = extract(xml, 10);

    assertTrue(text.startsWith("Broken\n"), text);
  }
}
