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
  final Podcast? podcast;
  final Brightness brightness;
  final ColorScheme fallBackColorScheme;

  final ScrollController scrollController = ScrollController();

  static const double _fadeEnd = 225; // fully opaque by this offset

  PodcastImageColorCubit(
    super.initialState, {
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
    if (scrollController.hasClients) {
      final offset = scrollController.offset;
      final t = ((offset) / (_fadeEnd)).clamp(0.0, 1.0);
      _log.fine('scaffold lerp position: $t');
      final newColor = Color.lerp(state.colorScheme.secondaryContainer, state.colorScheme.surface, t)!;
      if (newColor != state.scaffoldColor) {
        emit(state.copyWith(scaffoldColor: newColor));
      }
    }
  }

  Future<void> setPodcast(Podcast? podcast) async {
    if (podcast != null) {
      final podcastColor = await generatePalette(podcast.artUrl);
      _log.fine('found podcast image $podcastColor');
      if (podcastColor != null) {
        final colorScheme = ColorScheme.fromSeed(seedColor: podcastColor, brightness: brightness);
        emit(state.copyWith(colorScheme: colorScheme, initialized: true));
      } else {
        emit(state.copyWith(colorScheme: fallBackColorScheme, initialized: true));
      }
    } else {
      emit(state.copyWith(colorScheme: fallBackColorScheme, initialized: true));
    }

    _onScroll();
  }
}

@freezed
sealed class PodcastImageColorState with _$PodcastImageColorState {
  const factory PodcastImageColorState({
    required Color scaffoldColor,
    required ColorScheme colorScheme,
    @Default(false) bool initialized,
  }) = _PodcastImageColorState;
}
