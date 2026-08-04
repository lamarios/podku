import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

part 'podcast_image_color.freezed.dart';

final _log = Logger('PodcastImageColorCubit');

class PodcastImageColorCubit extends Cubit<PodcastImageColorState> {
  final ScrollController scrollController = ScrollController();

  static const double _fadeEnd = 225; // fully opaque by this offset

  PodcastImageColorCubit(super.initialState) {
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
      emit(state.copyWith(progress: t));
    }
  }
}

@freezed
sealed class PodcastImageColorState with _$PodcastImageColorState {
  const factory PodcastImageColorState({required double progress}) = _PodcastImageColorState;
}
