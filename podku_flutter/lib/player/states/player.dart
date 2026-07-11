import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart' as audio;
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/main.dart';
import 'package:podku/podcasts/models/podcast.dart';

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
    emit(state.copyWith(loading: true, showMiniPlayer: state.showMiniPlayer || true, showBigPlayer: false));
    final backendEpisode = await client.episodes.getEpisode(episode.id);
    if (backendEpisode != null && episode.audioUrl != null) {
      episode = backendEpisode;
      emit(state.copyWith(episode: episode, bufferPosition: Duration.zero, position: Duration.zero));
      if (player.playing) {
        player.stop();
      }
      await player.setUrl(
        episode.audioUrl!,
        tag: MediaItem(id: episode.id.uuid, title: episode.title, artUri: episode.podcast?.artUri, artist: episode.podcast?.name),
      );
      await player.play();
    }
  }

  void onPlaybackEvent(audio.PlaybackEvent playbackEvent) {}

  void showPlayers(bool miniPlayer, bool bigPlayer) {
    emit(state.copyWith(showMiniPlayer: miniPlayer, showBigPlayer: bigPlayer));
  }

  void onPlayerUpdate(audio.PlayerState state) {
    final wasPlaying = this.state.playing;
    emit(this.state.copyWith(playing: state.playing));
    if (this.state.loading && !wasPlaying && state.playing) {
      emit(this.state.copyWith(loading: false));
      if (player.duration != null && this.state.episode != null) {
        player.seek(Duration(seconds: (this.state.episode!.progress * player.duration!.inSeconds).round()));
      }
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
    @Default(false) bool showMiniPlayer,
    @Default(false) bool showBigPlayer,
  }) = _PlayerState;
}
