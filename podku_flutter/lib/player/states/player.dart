import 'package:audio_service/audio_service.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

part 'player.freezed.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit(super.initialState) {
    /*
    _player.androidPlaybackInfo.stream.playbackEventStream.listen((event) => onPlaybackEvent(event));
    _player.positionStream.listen((event) => updateProgress(event));
    _player.bufferedPositionStream.listen((event) => emit(state.copyWith(bufferPosition: event)));
    if (!kIsWeb) {
      _player.durationStream.listen(
        (event) => emit(state.copyWith(duration: event ?? Duration(seconds: 1))),
      );
    }
*/
    _player.playbackState.stream.listen(onStateChanged);
  }

  PodkuAudioHandler get _player => getIt.get<PodkuAudioHandler>();

  Future<void> updateProgress(Duration duration) async {}

  Future<void> playEpisode(Episode episode) async {
    if (state.episode?.id == episode.id) {
      return;
    }
    emit(state.copyWith(loading: true, showMiniPlayer: state.showMiniPlayer || true, showBigPlayer: false));
    final backendEpisode = await client.episodes.getEpisode(episode.id);
    if (backendEpisode != null && episode.audioUrl != null) {
      episode = backendEpisode;
      emit(
        state.copyWith(
          episode: episode,
          bufferPosition: Duration.zero,
          position: Duration.zero,
          duration: Duration(seconds: episode.durationSeconds ?? 1),
        ),
      );
      await _player.stop();


      await _player.playEpisode(
        episode
      );
      await _player.play();
    }
  }

  void playPause() {
    _player.playbackState.value.playing ? _player.pause() : _player.play();
  }

  void showPlayers(bool miniPlayer, bool bigPlayer) {
    emit(state.copyWith(showMiniPlayer: miniPlayer, showBigPlayer: bigPlayer));
  }

  void skip(int seconds) {
    _player.seek(state.position + Duration(seconds: seconds));
  }

  Future<void> onStateChanged(PlaybackState event) async {
    // handle when to remove the loading
    emit(state.copyWith(playing: event.playing));
    if (state.loading  && event.processingState == .ready && event.playing) {
      await _player.seek(Duration(seconds: (state.episode!.progress * state.duration.inSeconds).round()));
      emit(state.copyWith(loading: false));
    }

    emit(state.copyWith(position: event.position, bufferPosition: event.bufferedPosition));
    _updateProgress();
  }

  void _updateProgress() {
    if (!state.loading && state.episode != null) {
      final progress = state.position.inSeconds / state.duration.inSeconds;
      EasyThrottle.throttle(
        'progress-update',
        Duration(seconds: 5),
        () async {
          await client.episodes.setProgress(state.episode!.copyWith(progress: progress));
        },
      );
    }
  }
}

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    @Default(false) bool loading,
    Episode? episode,
    @Default(Duration(seconds: 0)) Duration position,
    @Default(Duration(seconds: 0)) Duration bufferPosition,
    @Default(Duration(seconds: 1)) Duration duration,
    @Default(false) bool playing,
    @Default(false) bool showMiniPlayer,
    @Default(false) bool showBigPlayer,
  }) = _PlayerState;
}
