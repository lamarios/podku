import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/main.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_shared/podku_shared.dart';

part 'player.freezed.dart';

final _log = Logger('PlayerCubit');

class PlayerCubit extends Cubit<PlayerState> with WidgetsBindingObserver {
  late BreakPoint _currentBreakPoint;

  WidgetsBinding get widgetsBinding => WidgetsBinding.instance;

  StreamSubscription<EpisodeProgress>? _streamSubscription;

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
    _player.mediaItem.stream.listen(episodeChangedListener);
    stream.map((event) => event.showBigPlayer).listen(handleBackButton);
    widgetsBinding.addObserver(this);
    var view = PlatformDispatcher.instance.views.first;
    _currentBreakPoint = BreakPoint.getFromSize((view.physicalSize / view.devicePixelRatio).width);

    getIt.get<ServerCubit>().playbackStream.stream.where((e) => e.newPlayback).listen(onNewPlayback);
  }

  @override
  Future<void> close() {
    widgetsBinding.removeObserver(this);
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  void didChangeMetrics() {
    final oldBreakPoint = _currentBreakPoint;

    var view = PlatformDispatcher.instance.views.first;
    _currentBreakPoint = BreakPoint.getFromSize((view.physicalSize / view.devicePixelRatio).width);

    // when we go from mobile to bigger, we need to switch to big player
    if (oldBreakPoint != _currentBreakPoint && oldBreakPoint == .mobile && state.showMiniPlayer) {
      emit(state.copyWith(showBigPlayer: true, showMiniPlayer: false));
    }

    handleBackButton(state.showBigPlayer);
  }

  PodkuAudioHandler get _player => getIt.get<PodkuAudioHandler>();

  Future<void> playEpisode(Episode episode, {bool offline = false}) async {
    try {
      if (state.episode?.id == episode.id) {
        return;
      }

      _log.fine('Playing episode: $episode');

      emit(state.copyWith(loading: true, showMiniPlayer: false, showBigPlayer: true));
      var backendEpisode = !kIsWeb && offline ? episode : await client.episodes.getEpisode(episode.id);

      // at this point we're probably trying to play an episode of a podcast we're not subscribed to
      if (!offline && backendEpisode == null) {
        _log.fine('Playing episode from podcast we\'re not subscribed to: $episode');
        backendEpisode = episode;
      }

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
        if (episode.podcast?.id.uuid != unsubbedPodcastUuid) {
          await client.episodes.startPlayback(episode, sessionId);
        }
        await _player.play();
      }
    } catch (e, s) {
      _log.severe('Failed to play episode', e, s);
      emit(state.copyWith(error: e, stackTrace: s));
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
    emit(state.copyWith(playing: event.playing, position: event.position, bufferPosition: event.bufferedPosition));
    _updateProgress();
  }

  void _updateProgress() {
    if (state.episode?.podcast?.id.uuid != unsubbedPodcastUuid && !state.loading && state.episode != null) {
      final episode = state.episode!;
      final progress = state.position.inSeconds / state.duration.inSeconds;
      EasyThrottle.throttle('progress-update-${state.episode?.id}', Duration(seconds: 5), () async {
        await _updateProgressInner(episode, progress);
      });
      // we do this so that whenever the episode stops playing, we save one last time
      EasyDebounce.debounce('progress-update-debounce-${state.episode?.id}', Duration(seconds: 2), () async {
        await _updateProgressInner(episode, progress);
        await getIt.get<DownloadManagerCubit>().getOfflineEpisodes();
      });
    } else {}
  }

  Future<void> _updateProgressInner(Episode episode, double progress) async {
    episode = episode.copyWith(progress: progress.clamp(0, 1));
    try {
      await client.episodes.setProgress(episode, sessionId);
    } catch (e) {
      _log.warning("Could not update episode progress", e);
    }

    try {
      if (await episode.validOfflineFiles) {
        final directory = await episode.episodeFolder(createIfMissing: true);

        final File data = File(p.join(directory.path, EpisodeDownloads.data));
        await data.writeAsString(jsonEncode(episode.toJson()));
      }
    } catch (e) {
      _log.warning('Failed to update progress on downloaded podcast', e);
    }
  }

  bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (_currentBreakPoint == .mobile) {
      emit(state.copyWith(showBigPlayer: false, showMiniPlayer: true));
    }
    return true;
  }

  void handleBackButton(bool showBigScreen) {
    if (_currentBreakPoint == .mobile && showBigScreen) {
      BackButtonInterceptor.add(backButtonInterceptor);
    } else {
      BackButtonInterceptor.remove(backButtonInterceptor);
    }
  }

  void stop() {
    _player.stop();
    emit(
      state.copyWith(
        showMiniPlayer: false,
        showBigPlayer: false,
        episode: null,
        position: .zero,
        bufferPosition: .zero,
        duration: .zero,
        playing: false,
      ),
    );
  }

  Future<void> episodeChangedListener(MediaItem? event) async {
    if (event != null) {
      var uuidValue = UuidValue.fromString(event.id);
      final episode =
          getIt.get<DownloadManagerCubit>().state.offlineEpisodes.where((e) => e.id == uuidValue).firstOrNull ??
          await client.episodes.getEpisode(uuidValue);

      if (episode != null) {
        emit(
          state.copyWith(
            episode: episode,
            duration: Duration(seconds: episode.durationSeconds ?? 1),
          ),
        );
      }
      if (!state.showBigPlayer && !state.showMiniPlayer) {
        emit(state.copyWith(showBigPlayer: true));
      }
    }
  }

  /// when a client starts playing what we're playing we stop here
  void onNewPlayback(EpisodeProgress event) {
    _log.fine('Received new playback event: $event');
    if (event.episodeId == state.episode?.id) {
      stop();
    }
  }

  void setSpeed(double speed) {
    _player.setSpeed(speed);
  }
}

@freezed
sealed class PlayerState with _$PlayerState implements WithError {
  @Implements<WithError>()
  const factory PlayerState({
    @Default(false) bool loading,
    Episode? episode,
    @Default(Duration(seconds: 0)) Duration position,
    @Default(Duration(seconds: 0)) Duration bufferPosition,
    @Default(Duration(seconds: 1)) Duration duration,
    @Default(false) bool playing,
    @Default(false) bool showMiniPlayer,
    @Default(false) bool showBigPlayer,
    dynamic error,
    StackTrace? stackTrace,
  }) = _PlayerState;
}
