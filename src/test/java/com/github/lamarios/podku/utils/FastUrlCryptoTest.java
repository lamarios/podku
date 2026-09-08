package com.github.lamarios.podku.utils;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

public class FastUrlCryptoTest {

  @Test
  public void testEncryptAndDecryptRoundtrip() throws Exception {
    FastUrlCrypto crypto = new FastUrlCrypto("my-test-secret-salt-12345");
    String url = "https://example.com/audio/podcast-episode-1.mp3?token=xyz123&track=1";

    String encrypted = crypto.encrypt(url);
    assertNotNull(encrypted);
    assertNotEquals(url, encrypted);
    // Should be URL-safe Base64 (no +, /, or = padding)
    assertFalse(encrypted.contains("+"));
    assertFalse(encrypted.contains("/"));
    assertFalse(encrypted.contains("="));

    String decrypted = crypto.decrypt(encrypted);
    assertEquals(url, decrypted);
  }

  @Test
  public void testNullAndEmptyHandling() throws Exception {
    FastUrlCrypto crypto = new FastUrlCrypto("test-secret");
    assertNull(crypto.encrypt(null));
    assertEquals("", crypto.encrypt(""));
  }

  @Test
  public void testStaticInstanceNotNull() {
    assertNotNull(FastUrlCrypto.instance);
  }

  @Test
  public void testDifferentCiphertextPerEncryptionDueToRandomIv() throws Exception {
    FastUrlCrypto crypto = new FastUrlCrypto("my-test-secret");
    String url = "https://example.com/podcast.rss";

    String enc1 = crypto.encrypt(url);
    String enc2 = crypto.encrypt(url);

    assertNotEquals(enc1, enc2);
    assertEquals(url, crypto.decrypt(enc1));
    assertEquals(url, crypto.decrypt(enc2));
  }
}
