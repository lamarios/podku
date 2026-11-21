import 'dart:async';

import 'package:anchored_list/anchored_list.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/parsed_transcript.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';

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
            index: findClosestTranscriptIndex(transcripts, playerCubit.state.position),
            loading: false,
            selectedLanguage: languages.first,
          ),
        );
        _jumpToCurrentLineOnceLaidOut();
      } else {
        emit(state.copyWith(loading: false));
      }
    }
  }

  /// Switches the transcript to another of the episode's languages, keeping the current line in view.
  Future<void> selectLanguage(String language) async {
    final episodeId = playerCubit.state.episode?.id;
    if (episodeId == null || language == state.selectedLanguage) {
      return;
    }
    emit(state.copyWith(loading: true));
    final List<EpisodeTranscript> transcript = await client.transcripts
        .getTranscript(id: episodeId, language: language)
        .then((value) => value.data ?? []);
    if (isClosed) {
      return;
    }
    // position on the current line right away rather than waiting for the next position update, which doesn't
    // come while paused
    emit(
      state.copyWith(
        transcript: transcript,
        selectedLanguage: language,
        index: findClosestTranscriptIndex(transcript, playerCubit.state.position),
        loading: false,
      ),
    );
    _jumpToCurrentLineOnceLaidOut();
  }

  /// The list is rebuilt when the transcript changes: jump to the current line once it has been laid out.
  void _jumpToCurrentLineOnceLaidOut() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!isClosed && listController.isAttached && state.index != -1) {
        listController.jumpToIndex(state.index, alignment: 0.5);
      }
    });
  }

  void onPositionChanged(Duration event) {
    var newIndex = findCurrentTranscriptIndex(state.transcript, event);
    if (newIndex != state.index && newIndex != -1) {
      emit(state.copyWith(index: newIndex));
      // the list is only built once the first index is known, so it isn't attached yet on the first update:
      // jump to the current line once it has been laid out
      if (!listController.isAttached) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!isClosed && listController.isAttached) {
            listController.jumpToIndex(state.index, alignment: 0.5);
          }
        });
        return;
      }
      listController.animateToIndex(
        newIndex,
        alignment: 0.5,
        duration: animationDuration,
        curve: Curves.easeInOutQuint,
      );
    }
  }

  /// Like [findCurrentTranscriptIndex], but when no line covers [position] (a gap between lines, or before the first
  /// one), returns the last line started before it, or the first line. Used when there is no previous line to keep
  /// highlighted, as the panel waits for an index before showing the transcript.
  static int findClosestTranscriptIndex(List<EpisodeTranscript> transcript, Duration position) {
    if (transcript.isEmpty) {
      return -1;
    }
    final index = findCurrentTranscriptIndex(transcript, position);
    if (index != -1) {
      return index;
    }
    final previous = transcript.lastIndexWhere((line) => line.startDuration <= position);
    return previous == -1 ? 0 : previous;
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
