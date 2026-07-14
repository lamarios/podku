import 'package:audio_service/audio_service.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
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
    stream.map((event) => event.showBigPlayer).listen(handleBackButton);
  }

  PodkuAudioHandler get _player => getIt.get<PodkuAudioHandler>();

  Future<void> updateProgress(Duration duration) async {}

  Future<void> playEpisode(Episode episode) async {
    try {
      if (state.episode?.id == episode.id) {
        return;
      }

      emit(
        state.copyWith(
          loading: true,
          showMiniPlayer: false,
          showBigPlayer: true,
        ),
      );
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

        await _player.playEpisode(episode);
        emit(state.copyWith(loading: false));
        await _player.play();
      }
    } catch (e) {
      print(e);
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
    emit(
      state.copyWith(
        playing: event.playing,
        position: event.position,
        bufferPosition: event.bufferedPosition,
      ),
    );
    _updateProgress();
  }

  void _updateProgress() {
    if (!state.loading && state.episode != null) {
      final progress = state.position.inSeconds / state.duration.inSeconds;
      EasyThrottle.throttle(
        'progress-update',
        Duration(seconds: 5),
        () async {
          await client.episodes.setProgress(
            state.episode!.copyWith(progress: progress),
          );
        },
      );
    }
  }

  bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    emit(state.copyWith(showBigPlayer: false, showMiniPlayer: true));
    return true;
  }

  void handleBackButton(bool showBigScreen) {
    if (showBigScreen) {
      BackButtonInterceptor.add(backButtonInterceptor);
    } else {
      BackButtonInterceptor.remove(backButtonInterceptor);
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
