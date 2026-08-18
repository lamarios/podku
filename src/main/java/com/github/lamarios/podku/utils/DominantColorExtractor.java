/* (C)2026 */
package com.github.lamarios.podku.utils;

import com.github.lamarios.podku.podcasts.Podcast;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import javax.imageio.ImageIO;

public class DominantColorExtractor {
  public static String extractDominantColorHex(Podcast podcast) throws Exception {
    return extractDominantColorHex(podcast.getArtworkUrl());
  }

  /**
   * Downloads an image from the given URL and returns its dominant color as a hex string (e.g.
   * "#3A5F8C") suitable for storing in a DB.
   */
  public static String extractDominantColorHex(String imageUrl) throws Exception {
    Color color = extractDominantColor(imageUrl);
    return toHex(color);
  }

  public static Color extractDominantColor(String imageUrl) throws Exception {
    BufferedImage image = ImageIO.read(new URL(imageUrl));
    if (image == null) {
      throw new IllegalArgumentException("Could not read image from URL: " + imageUrl);
    }
    return extractDominantColor(image);
  }

  public static Color extractDominantColor(BufferedImage image) {
    BufferedImage scaled = downscale(image, 100);

    Map<Integer, Integer> colorCounts = new HashMap<>();
    int width = scaled.getWidth();
    int height = scaled.getHeight();
    int quantizeFactor = 24;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int argb = scaled.getRGB(x, y);
        int alpha = (argb >> 24) & 0xFF;
        if (alpha < 125) {
          continue;
        }

        int r = (argb >> 16) & 0xFF;
        int g = (argb >> 8) & 0xFF;
        int b = argb & 0xFF;

        if (isNearWhiteOrBlack(r, g, b)) {
          continue;
        }

        int quantR = (r / quantizeFactor) * quantizeFactor;
        int quantG = (g / quantizeFactor) * quantizeFactor;
        int quantB = (b / quantizeFactor) * quantizeFactor;

        int key = (quantR << 16) | (quantG << 8) | quantB;
        colorCounts.merge(key, 1, Integer::sum);
      }
    }

    if (colorCounts.isEmpty()) {
      return averageColor(scaled);
    }

    int dominantKey =
        colorCounts.entrySet().stream().max(Map.Entry.comparingByValue()).orElseThrow().getKey();

    int r = (dominantKey >> 16) & 0xFF;
    int g = (dominantKey >> 8) & 0xFF;
    int b = dominantKey & 0xFF;

    return new Color(r, g, b);
  }

  /** Converts a Color to a "#RRGGBB" hex string. */
  public static String toHex(Color color) {
    return String.format("#%02X%02X%02X", color.getRed(), color.getGreen(), color.getBlue());
  }

  private static boolean isNearWhiteOrBlack(int r, int g, int b) {
    int brightness = (r + g + b) / 3;
    return brightness > 240 || brightness < 15;
  }

  private static BufferedImage downscale(BufferedImage original, int maxDimension) {
    int width = original.getWidth();
    int height = original.getHeight();
    if (width <= maxDimension && height <= maxDimension) {
      return original;
    }

    double scale = (double) maxDimension / Math.max(width, height);
    int newWidth = Math.max(1, (int) (width * scale));
    int newHeight = Math.max(1, (int) (height * scale));

    BufferedImage scaled = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_ARGB);
    scaled
        .getGraphics()
        .drawImage(
            original.getScaledInstance(newWidth, newHeight, java.awt.Image.SCALE_SMOOTH),
            0,
            0,
            null);
    return scaled;
  }

  private static Color averageColor(BufferedImage image) {
    long r = 0, g = 0, b = 0, count = 0;
    for (int x = 0; x < image.getWidth(); x++) {
      for (int y = 0; y < image.getHeight(); y++) {
        int argb = image.getRGB(x, y);
        r += (argb >> 16) & 0xFF;
        g += (argb >> 8) & 0xFF;
        b += argb & 0xFF;
        count++;
      }
    }
    if (count == 0) {
      return Color.GRAY;
    }
    return new Color((int) (r / count), (int) (g / count), (int) (b / count));
  }

  // Example usage
  public static void main(String[] args) throws Exception {
    String hex =
        extractDominantColorHex(
            "https://d3t3ozftmdmh3i.cloudfront.net/staging/podcast_uploaded_nologo/19411021/39a972f0779d74f2.jpeg");
    // e.g. "#3A5F8C"
    System.out.println("Dominant color: " + hex);
  }
}
