import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:openapi/openapi.dart';

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
      child: Builder(
        builder: (context) {
          return builder(context, colorScheme);
        },
      ),
    );
  }
}
