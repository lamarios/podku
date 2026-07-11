import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/main.dart';

part 'episodes.freezed.dart';

class EpisodeCubit extends Cubit<EpisodeState> {
  EpisodeCubit(super.initialState) {
    getEpisodes();
  }

  Future<void> getEpisodes({bool fromScratch = false}) async {
    emit(state.copyWith(loading: true));

    final episodes = await client.episodes.getEpisodes(fromScratch ? DateTime.now().millisecondsSinceEpoch : state.cursor);

    emit(state.copyWith(episodes: episodes, cursor: episodes.lastOrNull?.pubDateMillis, loading: false));
  }

  Future<void> loadMore() async {
    if (state.episodes.isNotEmpty) {
      emit(state.copyWith(loading: true));
      final episodes = List<Episode>.from(state.episodes);

      episodes.addAll(await client.episodes.getEpisodes(state.cursor));

      emit(state.copyWith(episodes: episodes, loading: false, cursor: episodes.lastOrNull?.pubDateMillis));
    }
  }
}

@freezed
sealed class EpisodeState with _$EpisodeState {
  const factory EpisodeState({@Default(false) bool loading, @Default([]) List<Episode> episodes, int? cursor}) = _EpisodeState;
}
