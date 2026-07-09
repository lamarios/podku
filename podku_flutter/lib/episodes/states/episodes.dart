import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/main.dart';

part 'episodes.freezed.dart';

class EpisodeCubit extends Cubit<EpisodeState> {
  EpisodeCubit(super.initialState) {
    getEpisodes();
  }

  Future<void> getEpisodes() async {
    emit(state.copyWith(loading: true));

    final episodes = await client.episodes.getEpisodes(state.cursor);

    emit(state.copyWith(episodes: episodes, cursor: episodes.lastOrNull?.pubDateMillis, loading: false));
  }
}

@freezed
sealed class EpisodeState with _$EpisodeState {
  const factory EpisodeState({@Default(false) bool loading, @Default([]) List<Episode> episodes, int? cursor}) = _EpisodeState;
}
