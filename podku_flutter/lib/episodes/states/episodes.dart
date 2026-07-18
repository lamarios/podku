import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/main.dart';

part 'episodes.freezed.dart';

const int _pageSize = 100;

class EpisodeCubit extends Cubit<EpisodeState> {
  EpisodeCubit(super.initialState) {
    getEpisodes();
  }

  Future<void> getEpisodes({bool refresh = false}) async {
    emit(state.copyWith(loading: !refresh));

    final episodes = await client.episodes.getEpisodes(
      after: refresh ? DateTime.now().millisecondsSinceEpoch : state.cursor,
      pageSize: refresh && state.episodes.isNotEmpty ? state.episodes.length : _pageSize,
    );

    if (!isClosed) {
      emit(state.copyWith(episodes: episodes, cursor: episodes.lastOrNull?.pubDateMillis, loading: false));
    }
  }

  Future<void> loadMore() async {
    if (state.episodes.isNotEmpty) {
      emit(state.copyWith(loading: true));
      final episodes = List<Episode>.from(state.episodes);

      episodes.addAll(await client.episodes.getEpisodes(after: state.cursor, pageSize: _pageSize));

      emit(state.copyWith(episodes: episodes, loading: false, cursor: episodes.lastOrNull?.pubDateMillis));
    }
  }
}

@freezed
sealed class EpisodeState with _$EpisodeState {
  const factory EpisodeState({@Default(false) bool loading, @Default([]) List<Episode> episodes, int? cursor}) =
      _EpisodeState;
}
