import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart' as audio;
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/main.dart';

part 'player.freezed.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final player = audio.AudioPlayer();

  PlayerCubit(super.initialState) {
    player.playerStateStream.listen((event) => onPlayerUpdate(event));
    player.playbackEventStream.listen((event) => onPlaybackEvent(event));
    player.positionStream.listen((event) => updateProgress(event));
    player.bufferedPositionStream.listen((event) => emit(state.copyWith(bufferPosition: event)));
  }

  @override
  Future<void> close() async {
    player.dispose();
    super.close();
  }

  Future<void> updateProgress(Duration duration) async {
    if (player.duration != null && state.episode != null) {
      final progress = duration.inSeconds / player.duration!.inSeconds;
      emit(
        state.copyWith(
          position: duration,
        ),
      );
      EasyThrottle.throttle(
        'progress-update',
        Duration(seconds: 5),
        () async {
          await client.episodes.setProgress(state.episode!.copyWith(progress: progress));
        },
      );
    }
  }

  Future<void> playEpisode(Episode episode) async {
    emit(state.copyWith(loading: true));
    final backendEpisode = await client.episodes.getEpisode(episode.id);
    if (backendEpisode != null && episode.audioUrl != null) {
      episode = backendEpisode;
      emit(state.copyWith(episode: episode, bufferPosition: Duration.zero, position: Duration.zero));
      if (player.playing) {
        player.stop();
      }
      await player.setUrl(episode.audioUrl!);
      await player.play();
      if (player.duration != null) {
        player.seek(Duration(seconds: (episode.progress * player.duration!.inSeconds).round()));
      }
    }
  }

  void onPlaybackEvent(audio.PlaybackEvent playbackEvent) {}

  void setMiniPlayer(bool show) {
    emit(state.copyWith(showMiniPlayer: show));
  }

  void onPlayerUpdate(audio.PlayerState state) {
    final wasPlaying = this.state.playing;
    emit(this.state.copyWith(playing: state.playing));
    if (this.state.loading && !wasPlaying && state.playing) {
      emit(this.state.copyWith(loading: false));
    }
    /*
    state.
    switch(state.processingState){

    }
*/
  }

  void skip(int seconds) {
    player.seek(state.position + Duration(seconds: seconds));
  }
}

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    @Default(false) bool loading,
    Episode? episode,
    @Default(Duration(seconds: 0)) Duration position,
    @Default(Duration(seconds: 0)) Duration bufferPosition,
    @Default(false) bool playing,
    @Default(true) bool showMiniPlayer,
  }) = _PlayerState;
}
