import 'package:material_ui/material_ui.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/utils/views/components/legacy_material_bridge.dart';

class PodcastColorProvider extends StatelessWidget {
  final Podcast? podcast;
  final PodcastLight? podcastLight;
  final Widget Function(BuildContext context, M3EColorScheme colorScheme) builder;

  const PodcastColorProvider({super.key, this.podcast, this.podcastLight, required this.builder})
    : assert(podcast == null || podcastLight == null);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.brightnessOf(context);
    final colorScheme = (podcast?.color?.isNotEmpty ?? false) || (podcastLight?.color?.isNotEmpty ?? false)
        ? M3EColorScheme.fromSeed(
            Color(int.parse((podcast?.color ?? podcastLight!.color!).substring(1), radix: 16)),
            brightness: brightness,
          )
        : M3ETheme.of(context).colorScheme;
    return M3ETheme(
      autoTheming: true,
      initialTheme: brightness,
      data: M3EThemeData.fromMaterial(
        Theme.of(context).copyWith(brightness: brightness),
      ).copyWith(colorScheme: colorScheme),
      // M3ETheme only sets the material_ui theme, re-bridge so dependencies still on package:flutter/material.dart
      // (e.g. material_loading_indicator) also get the podcast colors
      child: LegacyMaterialBridge(
        child: Builder(
          builder: (context) {
            return builder(context, colorScheme);
          },
        ),
      ),
    );
  }
}
