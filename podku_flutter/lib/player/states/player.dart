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
  }

  @override
  Future<void> close() async {
    player.dispose();
    super.close();
  }

  Future<void> updateProgress(Duration duration) async {
    if (player.duration != null && state.episode != null) {
      final progress = duration.inSeconds / player.duration!.inSeconds;
      EasyThrottle.throttle(
        'progress-update',
        Duration(seconds: 5),
        () async {
          emit(state.copyWith(episode: state.episode!.copyWith(progress: progress)));
          await client.episodes.setProgress(state.episode!.copyWith(progress: progress));
        },
      );
    }
  }

  Future<void> playEpisode(Episode episode) async {
    if (episode.audioUrl != null) {
      emit(state.copyWith(episode: episode));
      if (player.playing) {
        player.stop();
      }
      await player.setUrl(episode.audioUrl!);
      player.play();
    }
  }

  void onPlaybackEvent(audio.PlaybackEvent playbackEvent) {}

  void onPlayerUpdate(audio.PlayerState state) {
    /*
    state.
    switch(state.processingState){

    }
*/
  }
}

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({Episode? episode}) = _PlayerState;
}
