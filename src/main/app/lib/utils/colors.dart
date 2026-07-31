// Generate palette from an image
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

Future<Color?> generatePalette(String imageUrl) async {
  // Load your image
  final ImageProvider imageProvider = CachedNetworkImageProvider(imageUrl);

  // Generate palette
  final PaletteGeneratorMaster paletteGenerator = await PaletteGeneratorMaster.fromImageProvider(
    imageProvider,
    maximumColorCount: 16,
    generateHarmony: true, // Generate color harmony
  );

  // Access extracted colors
  // final Color? dominantColor = paletteGenerator.dominantColor?.color;
  final Color? vibrantColor = paletteGenerator.vibrantColor?.color;
  // final Color? mutedColor = paletteGenerator.mutedColor?.color;

  /*
  // Get all extracted colors
  final List<PaletteColorMaster> allColors = paletteGenerator.paletteColors;

  // Get harmony colors
  final List<ColorHarmonyMaster> harmonyColors = paletteGenerator.harmonyColors;
*/

  // Use colors in your UI
  return vibrantColor;
}

Color darken(Color color, [double amount = 0.2]) {
  return Color.lerp(color, Colors.black, amount)!;
}

Color lighten(Color color, [double amount = 0.2]) {
  return Color.lerp(color, Colors.white, amount)!;
}
