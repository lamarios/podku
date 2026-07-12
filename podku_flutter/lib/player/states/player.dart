import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart' as audio;
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/main.dart';
import 'package:podku/podcasts/models/podcast.dart';

part 'player.freezed.dart';

class PlayerCubit extends Cubit<PlayerState> {
  final _player = audio.AudioPlayer();

  PlayerCubit(super.initialState) {
    _player.playerStateStream.listen((event) => onPlayerUpdate(event));
    _player.playbackEventStream.listen((event) => onPlaybackEvent(event));
    _player.positionStream.listen((event) => updateProgress(event));
    _player.bufferedPositionStream.listen((event) => emit(state.copyWith(bufferPosition: event)));
    if (!kIsWeb) {
      _player.durationStream.listen(
        (event) => emit(state.copyWith(duration: event ?? Duration(seconds: 1))),
      );
    }
  }

  @override
  Future<void> close() async {
    _player.dispose();
    super.close();
  }

  Future<void> updateProgress(Duration duration) async {
    if (!state.loading && _player.duration != null && state.episode != null) {
      final progress = duration.inSeconds / _player.duration!.inSeconds;
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
      emit(
        state.copyWith(
          episode: episode,
          bufferPosition: Duration.zero,
          position: Duration.zero,
          duration: Duration(seconds: episode.durationSeconds ?? 1),
        ),
      );
      if (_player.playing) {
        _player.stop();
      }

      var audioProxyUrl = episode.audioProxyUrl;

      await _player.setUrl(
        audioProxyUrl,
        // episode.audioUrl ?? '',
        tag: MediaItem(id: episode.id.uuid, title: episode.title, artUri: episode.podcast?.artUri, artist: episode.podcast?.name),
      );
      await _player.play();
    }
  }

  void onPlaybackEvent(audio.PlaybackEvent playbackEvent) {}

  void playPause() {
    _player.playing ? _player.pause() : _player.play();
  }

  void showPlayers(bool miniPlayer, bool bigPlayer) {
    emit(state.copyWith(showMiniPlayer: miniPlayer, showBigPlayer: bigPlayer));
  }

  void onPlayerUpdate(audio.PlayerState state) {
    final wasPlaying = this.state.playing;
    emit(this.state.copyWith(playing: state.playing));
    if (this.state.loading && !wasPlaying && state.playing) {
      emit(this.state.copyWith(loading: false));
      _player.seek(Duration(seconds: (this.state.episode!.progress * this.state.duration.inSeconds).round()));
    }
  }

  void skip(int seconds) {
    _player.seek(state.position + Duration(seconds: seconds));
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
