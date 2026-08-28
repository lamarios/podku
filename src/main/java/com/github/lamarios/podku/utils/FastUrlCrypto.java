package com.github.lamarios.podku.utils;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Encrypts and decrypts URLs using AES-128 in CTR mode with a random per-message IV. The secret is
 * derived from a SHA-256 hash so the same key is reproduced across restarts (from the {@code SALT}
 * environment variable). The ciphertext is stored as a URL-safe Base64 string with the IV
 * prepended.
 */
public class FastUrlCrypto {
  private static final String ALGORITHM = "AES/CTR/NoPadding";
  private static final int IV_LENGTH = 16;
  private final SecretKeySpec keySpec;
  private final SecureRandom secureRandom = new SecureRandom();
  public static FastUrlCrypto instance;

  static {
    try {
      instance = new FastUrlCrypto(System.getenv("SALT"));
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }

  /**
   * Initializes the crypto utility with a single static secret. URLs will remain decryptable across
   * server restarts.
   *
   * @param secret Your main application secret
   */
  public FastUrlCrypto(String secret) throws Exception {
    // Hash the single secret string to get a predictable stream of bytes
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] hashedKey = md.digest(secret.getBytes(StandardCharsets.UTF_8));
    // AES-128 requires exactly 16 bytes. We take the first 16 bytes of the SHA-256 hash.
    byte[] aesKey = new byte[16];
    System.arraycopy(hashedKey, 0, aesKey, 0, 16);
    this.keySpec = new SecretKeySpec(aesKey, "AES");
  }

  /**
   * Encrypts {@code plainUrl} into a URL-safe Base64 string, prepending a fresh random IV.
   *
   * @param plainUrl the plaintext URL; returned unchanged when {@code null} or empty
   * @return the encrypted, URL-safe Base64 representation of the input URL
   */
  public String encrypt(String plainUrl) throws Exception {
    // 1. ADD THIS NULL CHECK
    if (plainUrl == null || plainUrl.isEmpty()) {
      return plainUrl;
    }

    byte[] iv = new byte[IV_LENGTH];
    secureRandom.nextBytes(iv);
    IvParameterSpec ivSpec = new IvParameterSpec(iv);

    Cipher cipher = Cipher.getInstance(ALGORITHM);
    cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);

    byte[] plaintext = plainUrl.getBytes(StandardCharsets.UTF_8);
    byte[] ciphertext = cipher.doFinal(plaintext);

    ByteBuffer buffer = ByteBuffer.allocate(IV_LENGTH + ciphertext.length);
    buffer.put(iv);
    buffer.put(ciphertext);

    return Base64.getUrlEncoder().withoutPadding().encodeToString(buffer.array());
  }

  /**
   * Reverses {@link #encrypt(String)}: extracts the IV, decrypts the remainder and returns the
   * original plaintext URL.
   *
   * @param encryptedUrlSafe the URL-safe Base64 string produced by {@link #encrypt(String)}
   * @return the original plaintext URL
   */
  public String decrypt(String encryptedUrlSafe) throws Exception {
    byte[] decoded = Base64.getUrlDecoder().decode(encryptedUrlSafe);

    byte[] iv = new byte[IV_LENGTH];
    System.arraycopy(decoded, 0, iv, 0, IV_LENGTH);
    IvParameterSpec ivSpec = new IvParameterSpec(iv);

    int cipherTextLength = decoded.length - IV_LENGTH;
    byte[] ciphertext = new byte[cipherTextLength];
    System.arraycopy(decoded, IV_LENGTH, ciphertext, 0, cipherTextLength);

    Cipher cipher = Cipher.getInstance(ALGORITHM);
    cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);

    byte[] plaintext = cipher.doFinal(ciphertext);
    return new String(plaintext, StandardCharsets.UTF_8);
  }
}
