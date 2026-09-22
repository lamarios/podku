import 'dart:async';

import 'package:anchored_list/anchored_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/parsed_transcript.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';

part 'transcript.freezed.dart';

class TranscriptCubit extends Cubit<TranscriptState> {
  StreamSubscription<Duration>? playerPositionStream;
  final AnchoredListController listController = AnchoredListController();
  final PlayerCubit playerCubit;

  TranscriptCubit(super.initialState, {required this.playerCubit}) {
    init();
  }

  Future<void> init() async {
    setEpisode(playerCubit.state.episode);
    playerPositionStream = playerCubit.stream.map((event) => event.position).listen(onPositionChanged);
  }

  @override
  Future<void> close() async {
    playerPositionStream?.cancel();
    listController.dispose();
    super.close();
  }

  Future<void> setEpisode(Episode? episode) async {
    if (episode != null) {
      emit(state.copyWith(loading: true));
      final languages = await client.transcripts
          .getEpisodeLanguages(id: episode.id ?? '')
          .then((value) => value.data ?? <String>[]);
      if (languages.isNotEmpty) {
        final List<EpisodeTranscript> transcripts = await client.transcripts
            .getTranscript(id: episode.id ?? '', language: languages.first)
            .then((value) => value.data ?? []);
        emit(
          state.copyWith(
            languages: languages,
            transcript: transcripts,
            index: -1,
            loading: false,
            selectedLanguage: languages.first,
          ),
        );
      } else {
        emit(state.copyWith(loading: false));
      }
    }
  }

  void onPositionChanged(Duration event) {
    var newIndex = findCurrentTranscriptIndex(state.transcript, event);
    if (newIndex != state.index && newIndex != -1) {
      emit(state.copyWith(index: newIndex));
      listController.jumpToIndex(
        newIndex,
        alignment: 0.5,
        // duration: Duration.zero,
        // curve: Curves.easeInOutQuint,
        // alignment: 0,
      );
    }
  }

  static int findCurrentTranscriptIndex(List<EpisodeTranscript> transcript, Duration position) {
    int low = 0;
    int high = transcript.length - 1;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final entry = transcript[mid];

      if (position < entry.startDuration) {
        high = mid - 1;
      } else if (position >= entry.endDuration) {
        low = mid + 1;
      } else {
        return mid; // position falls within [start, end)
      }
    }

    return -1; // no entry covers this position (gap, or before first/after last)
  }
}

@freezed
sealed class TranscriptState with _$TranscriptState {
  const factory TranscriptState({
    @Default(true) bool loading,
    @Default(-1) int index,
    String? selectedLanguage,
    @Default([]) List<EpisodeTranscript> transcript,
    @Default([]) List<String> languages,
  }) = _TranscriptState;
}
