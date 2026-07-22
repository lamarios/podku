import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/main.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_client/podku_client.dart';

part 'episodes.freezed.dart';

const int _pageSize = 100;

class EpisodesCubit extends Cubit<EpisodesState> {
  EpisodesCubit(super.initialState) {
    getEpisodes();
  }

  Future<void> getEpisodes({bool refresh = false}) async {
    try {
      emit(state.copyWith(loading: !refresh));

      final episodes = await client.episodes.getEpisodes(
        after: refresh ? DateTime.now().millisecondsSinceEpoch : state.cursor,
        pageSize: refresh && state.episodes.isNotEmpty ? state.episodes.length : _pageSize,
      );

      if (!isClosed) {
        emit(state.copyWith(episodes: episodes, cursor: episodes.lastOrNull?.pubDateMillis, loading: false));
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
    }
  }

  Future<void> loadMore() async {
    try {
      if (state.episodes.isNotEmpty) {
        emit(state.copyWith(loading: true));
        final episodes = List<Episode>.from(state.episodes);

        episodes.addAll(await client.episodes.getEpisodes(after: state.cursor, pageSize: _pageSize));

        emit(state.copyWith(episodes: episodes, loading: false, cursor: episodes.lastOrNull?.pubDateMillis));
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
    }
  }

  Future<void> markEpisodeAsPlayed(Episode episode) async {
    try {
      List<Episode> episodes = List.from(state.episodes);
      final index = episodes.indexOf(episode);
      if (index != -1) {
        episodes[index] = episode.copyWith(progress: 1);
      }
      emit(state.copyWith(episodes: episodes));
      await client.episodes.setProgress(episode.copyWith(progress: 1), sessionId);
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }
}

@freezed
sealed class EpisodesState with _$EpisodesState implements WithError {
  @Implements<WithError>()
  const factory EpisodesState({
    @Default(false) bool loading,
    @Default([]) List<Episode> episodes,
    int? cursor,
    dynamic error,
    StackTrace? stackTrace,
  }) = _EpisodesState;
}
