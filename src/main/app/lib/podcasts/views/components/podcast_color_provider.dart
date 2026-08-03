import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/states/podcast_image_color.dart';

class PodcastColorProvider extends StatelessWidget {
  final Podcast? podcast;
  final PodcastLight? podcastLight;
  final Widget Function(BuildContext context, M3EColorScheme colorScheme) builder;

  const PodcastColorProvider({super.key, this.podcast, this.podcastLight, required this.builder})
    : assert(podcast == null || podcastLight == null);

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final brightness = Theme.brightnessOf(context);
    return BlocProvider(
      create: (context) => PodcastImageColorCubit(
        PodcastImageColorState(colorScheme: colors, scaffoldColor: colors.surface),
        brightness: brightness,
        fallBackColorScheme: colors,
      )..setPodcast(podcast: podcast, podcastLight: podcastLight),

      child: BlocBuilder<PodcastImageColorCubit, PodcastImageColorState>(
        builder: (context, state) {
          return builder(context, state.colorScheme);
        },
      ),
    );
  }
}
