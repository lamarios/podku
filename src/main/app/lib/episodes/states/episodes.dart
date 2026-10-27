import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/with_error.dart';

part 'episodes.freezed.dart';

const int _pageSize = 100;

enum EpisodeThresholds {
  today,
  pastWeek,
  older;

  static EpisodeThresholds match(Episode episode) {
    return EpisodeThresholds.values.firstWhere((element) => (episode.pubDateMillis ?? 1) > element.startTime);
  }

  int get startTime {
    final now = DateTime.now();
    final startOfToday = now.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    return switch (this) {
      today => startOfToday.millisecondsSinceEpoch,
      // rolling 7 days including today; copyWith rolls day underflow into the previous month/year
      pastWeek => startOfToday.copyWith(day: now.day - 6).millisecondsSinceEpoch,
      older => 0,
    };
  }
}

class EpisodesCubit extends Cubit<EpisodesState> {
  late final StreamSubscription<InternetConnectionStatus>? connectionSub;
  final ScrollController scrollController = ScrollController();

  EpisodesCubit(super.initialState) {
    getEpisodes();

    connectionSub = getIt.get<ServerCubit>().stream.map((event) => event.status).listen(onConnectionStatusChange);

    scrollController.addListener(onScrollChange);
  }

  @override
  Future<void> close() async {
    scrollController.dispose();
    super.close();
  }

  Future<void> getEpisodes({bool refresh = false}) async {
    if (!isOnline) {
      return;
    }
    try {
      emit(state.copyWith(loading: !refresh));

      final episodes =
          await client.episodes
              .getEpisodes(
                before: refresh ? DateTime.now().millisecondsSinceEpoch : state.cursor,
                pageSize: refresh && state.episodes.isNotEmpty ? state.episodeCount : _pageSize,
              )
              .then((value) => value.data) ??
          [];

      if (!isClosed) {
        emit(
          state.copyWith(episodes: _mapEpisodes(episodes), cursor: episodes.lastOrNull?.pubDateMillis, loading: false),
        );
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
    }
  }

  Map<EpisodeThresholds, List<Episode>> _mapEpisodes(List<Episode> episodes) {
    Map<EpisodeThresholds, List<Episode>> mappedEpisodes = {};
    for (var e in episodes) {
      final threshold = EpisodeThresholds.match(e);

      mappedEpisodes.putIfAbsent(threshold, () => []);
      mappedEpisodes[threshold]?.add(e);
    }

    return mappedEpisodes;
  }

  Future<void> loadMore() async {
    if (!isOnline) {
      return;
    }
    try {
      if (state.episodes.isNotEmpty) {
        emit(state.copyWith(loading: true));
        final episodes = Map<EpisodeThresholds, List<Episode>>.from(state.episodes);

        final newEpisodes = (await client.episodes.getEpisodes(before: state.cursor, pageSize: _pageSize)).data ?? [];
        final mappedNewEpisodes = _mapEpisodes(newEpisodes);

        for (var entry in mappedNewEpisodes.entries) {
          // build a new list, Map.from is shallow and adding to the existing list would also change the previous state
          episodes[entry.key] = [...?episodes[entry.key], ...entry.value];
        }
        emit(state.copyWith(episodes: episodes, loading: false, cursor: newEpisodes.lastOrNull?.pubDateMillis));
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
    }
  }

  Future<void> markEpisodeAsPlayed(Episode episode) async {
    try {
      Map<EpisodeThresholds, List<Episode>> episodes = Map.from(state.episodes);
      // search every group rather than using EpisodeThresholds.match, the thresholds move with the clock
      // so the episode may no longer match the group it was put in when loaded
      for (final MapEntry(key: threshold, value: list) in state.episodes.entries) {
        final index = list.indexWhere((e) => e.id == episode.id);
        if (index != -1) {
          // copy the list, Map.from is shallow and mutating the existing list would also change the previous state
          episodes[threshold] = List.of(list)
            ..[index] = episode.copyWith(progress: episode.durationSeconds?.toDouble());
          break;
        }
      }
      emit(state.copyWith(episodes: episodes));
      await client.episodes.setProgress(
        playbackProgress: PlaybackProgress(
          player: sessionId,
          episodeId: episode.id,
          progress: episode.durationSeconds?.toDouble() ?? 0,
          newPlayback: false,
        ),
      );
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }

  void onConnectionStatusChange(InternetConnectionStatus event) {
    if (event == .connected || event == .slow) {
      getEpisodes(refresh: true);
    } else {
      emit(state.copyWith(episodes: {}));
    }
  }

  void onScrollChange() {
    if (scrollController.position.extentAfter < 300 && state.episodeCount % _pageSize == 0) {
      EasyDebounce.debounce('load-more-episodes', Duration(milliseconds: 250), loadMore);
    }
  }
}

@freezed
sealed class EpisodesState with _$EpisodesState implements WithError {
  @Implements<WithError>()
  const factory EpisodesState({
    @Default(false) bool loading,
    @Default({}) Map<EpisodeThresholds, List<Episode>> episodes,
    int? cursor,
    dynamic error,
    StackTrace? stackTrace,
  }) = _EpisodesState;

  const EpisodesState._();

  int get episodeCount => episodes.values.fold(0, (count, list) => count + list.length);
}
