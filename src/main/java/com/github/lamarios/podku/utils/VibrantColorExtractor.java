/* (C)2026 */
package com.github.lamarios.podku.utils;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;

public class VibrantColorExtractor {
    // Mirrors Android Palette API / palette_generator's "vibrant" target constants
    private static final float MIN_SATURATION = 0.35f;
    private static final float TARGET_SATURATION = 1.0f;
    private static final float MIN_LUMA = 0.30f;
    private static final float MAX_LUMA = 0.70f;
    private static final float TARGET_LUMA = 0.50f;
    private static final float WEIGHT_SATURATION = 0.24f;
    private static final float WEIGHT_LUMA = 0.52f;
    private static final float WEIGHT_POPULATION = 0.24f;

    private static class Swatch {
        int r, g, b;
        int population;
        // 0: hue, 1: saturation, 2: lightness
        float[] hsl;

        Swatch(int r, int g, int b, int population) {
            this.r = r;
            this.g = g;
            this.b = b;
            this.population = population;
            this.hsl = rgbToHsl(r, g, b);
        }

        Color toColor() {
            return new Color(r, g, b);
        }
    }

    /**
     * Downloads an image and returns the vibrant color as "#RRGGBB", or null if no color qualifies.
     */
    public static String extractVibrantColorHex(String imageUrl) throws Exception {
        BufferedImage image = ImageIO.read(new URL(imageUrl));
        if (image == null) {
            throw new IllegalArgumentException("Could not read image from URL: " + imageUrl);
        }
        Color vibrant = extractVibrantColor(image);
        return vibrant == null ? null : toHex(vibrant);
    }

    public static Color extractVibrantColor(BufferedImage image) {
        List<Swatch> swatches = quantize(downscale(image, 100));
        if (swatches.isEmpty()) {
            return null;
        }

        int maxPopulation = swatches
            .stream()
            .mapToInt(s -> s.population)
            .max()
            .orElse(1);

        Swatch best = null;
        float bestScore = -1f;

        for (Swatch s : swatches) {
            float saturation = s.hsl[1];
            float luma = s.hsl[2];
            // Hard filter: must fall inside the vibrant target's acceptable range
            if (saturation < MIN_SATURATION || luma < MIN_LUMA || luma > MAX_LUMA) {
                continue;
            }

            float score = weightedScore(saturation, luma, s.population, maxPopulation);
            if (score > bestScore) {
                bestScore = score;
                best = s;
            }
        }
        // Fallback: relax the saturation constraint a bit if nothing qualified
        if (best == null) {
            for (Swatch s : swatches) {
                float saturation = s.hsl[1];
                float luma = s.hsl[2];
                if (luma < MIN_LUMA || luma > MAX_LUMA) {
                    continue;
                }
                float score = weightedScore(saturation, luma, s.population, maxPopulation);
                if (score > bestScore) {
                    bestScore = score;
                    best = s;
                }
            }
        }

        return best == null ? null : best.toColor();
    }

    private static float weightedScore(float saturation, float luma, int population, int maxPopulation) {
        float saturationScore = 1f - Math.abs(saturation - TARGET_SATURATION);
        float lumaScore = 1f - Math.abs(luma - TARGET_LUMA);
        float populationScore = (float) population / maxPopulation;

        return (saturationScore * WEIGHT_SATURATION)
                + (lumaScore * WEIGHT_LUMA)
                + (populationScore * WEIGHT_POPULATION);
    }

    /**
     * Quantizes pixels into color buckets with population counts, skipping transparent pixels.
     */
    private static List<Swatch> quantize(BufferedImage image) {
        // finer than pure-dominant extraction, so vibrant hues aren't lost
        int quantizeFactor = 16;
        java.util.Map<Integer, Integer> counts = new java.util.HashMap<>();

        int width = image.getWidth();
        int height = image.getHeight();

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                int argb = image.getRGB(x, y);
                int alpha = (argb >> 24) & 0xFF;
                if (alpha < 125) {
                    continue;
                }

                int r = (argb >> 16) & 0xFF;
                int g = (argb >> 8) & 0xFF;
                int b = argb & 0xFF;

                int quantR = (r / quantizeFactor) * quantizeFactor;
                int quantG = (g / quantizeFactor) * quantizeFactor;
                int quantB = (b / quantizeFactor) * quantizeFactor;

                int key = (quantR << 16) | (quantG << 8) | quantB;
                counts.merge(key, 1, Integer::sum);
            }
        }

        List<Swatch> swatches = new ArrayList<>();
        for (var entry : counts.entrySet()) {
            int key = entry.getKey();
            int r = (key >> 16) & 0xFF;
            int g = (key >> 8) & 0xFF;
            int b = key & 0xFF;
            swatches.add(new Swatch(r, g, b, entry.getValue()));
        }
        return swatches;
    }

    private static float[] rgbToHsl(int r, int g, int b) {
        float rf = r / 255f, gf = g / 255f, bf = b / 255f;
        float max = Math.max(rf, Math.max(gf, bf));
        float min = Math.min(rf, Math.min(gf, bf));
        float h, s, l = (max + min) / 2f;

        if (max == min) {
            h = s = 0f;
        } else {
            float d = max - min;
            s = l > 0.5f ? d / (2f - max - min) : d / (max + min);
            if (max == rf) {
                h = (gf - bf) / d + (gf < bf ? 6f : 0f);
            } else if (max == gf) {
                h = (bf - rf) / d + 2f;
            } else {
                h = (rf - gf) / d + 4f;
            }
            h /= 6f;
        }
        return new float[] {h, s, l};
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
            .drawImage(original.getScaledInstance(newWidth, newHeight, java.awt.Image.SCALE_SMOOTH), 0, 0, null);
        return scaled;
    }

    private static String toHex(Color color) {
        return String.format("#%02X%02X%02X", color.getRed(), color.getGreen(), color.getBlue());
    }

    // Example usage
    public static void main(String[] args) throws Exception {
        String hex = extractVibrantColorHex("https://example.com/podcast-cover.jpg");
        System.out.println("Vibrant color: " + hex);
    }
}
