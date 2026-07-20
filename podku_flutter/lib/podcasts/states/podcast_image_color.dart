import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku/utils/colors.dart';
import 'package:podku_client/podku_client.dart';

part 'podcast_image_color.freezed.dart';

final _log = Logger('PodcastImageColorCubit');

class PodcastImageColorCubit extends Cubit<PodcastImageColorState> {
  final Color surfaceColor;
  final Podcast? podcast;
  final Brightness brightness;
  final ColorScheme fallBackColorScheme;

  final ScrollController scrollController = ScrollController();

  static const double _fadeStart = 0;
  static const double _fadeEnd = 100; // fully opaque by this offset

  PodcastImageColorCubit(
    super.initialState, {
    required this.surfaceColor,
    this.podcast,
    required this.brightness,
    required this.fallBackColorScheme,
  }) {
    scrollController.addListener(_onScroll);
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }

  void _onScroll() {
    final offset = scrollController.offset;
    final t = ((offset - _fadeStart) / (_fadeEnd - _fadeStart)).clamp(0.0, 1.0);
    final newColor = Color.lerp(state.colorScheme.secondaryContainer, surfaceColor, t)!;
    if (newColor != state.scaffoldColor) {
      emit(state.copyWith(scaffoldColor: newColor));
    }
  }

  Future<void> setPodcast(Podcast? podcast) async {
    if (podcast != null) {
      final podcastColor = await generatePalette(podcast.artUrl);
      _log.fine('found podcast image $podcastColor');
      if (podcastColor != null) {
        final colorScheme = ColorScheme.fromSeed(seedColor: podcastColor, brightness: brightness);
        emit(state.copyWith(colorScheme: colorScheme));
      } else {
        emit(state.copyWith(colorScheme: fallBackColorScheme));
      }
    } else {
      emit(state.copyWith(colorScheme: fallBackColorScheme));
    }

    _onScroll();
  }
}

@freezed
sealed class PodcastImageColorState with _$PodcastImageColorState {
  const factory PodcastImageColorState({required Color scaffoldColor, required ColorScheme colorScheme}) =
      _PodcastImageColorState;
}
