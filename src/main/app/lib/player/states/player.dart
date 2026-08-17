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
import 'package:openapi/openapi.dart';
import 'package:path/path.dart' as p;
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/main.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/offline_episodes/utils.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_shared/podku_shared.dart';

part 'player.freezed.dart';

final _log = Logger('PlayerCubit');

class PlayerCubit extends Cubit<PlayerState> with WidgetsBindingObserver {
  late BreakPoint _currentBreakPoint;

  WidgetsBinding get widgetsBinding => WidgetsBinding.instance;

  StreamSubscription<PlaybackProgress>? _streamSubscription;
  StreamSubscription<RemoteCommand>? _remoteCommandSubscription;
  StreamSubscription<PlayerStatus>? _playerStatusSubscription;
  StreamSubscription<TransferPlayback>? _transferPlaybackSubscription;
  StreamSubscription<PlayerInfo?>? _currentPlayerSubscription;
  StreamSubscription<PlaybackState>? _playbackStateSubscription;
  StreamSubscription<MediaItem?>? _mediaItemSubscription;
  StreamSubscription<Duration>? _durationChangedSubscription;
  StreamSubscription<bool>? _showBigPlayerSubscription;

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
    listenToPlayerEvents();
    _showBigPlayerSubscription = stream.map((event) => event.showBigPlayer).listen(handleBackButton);
    widgetsBinding.addObserver(this);
    var view = PlatformDispatcher.instance.views.first;
    _currentBreakPoint = BreakPoint.getFromSize((view.physicalSize / view.devicePixelRatio).width);
    listenToEvents();
  }

  @override
  Future<void> close() async {
    widgetsBinding.removeObserver(this);
    await _showBigPlayerSubscription?.cancel();
    await stopListeningToEvents();
    await stopListeningToPlayerEvents();
    return super.close();
  }

  void listenToPlayerEvents() {
    _playbackStateSubscription = _player.playbackState.stream.listen(onStateChanged);
    _mediaItemSubscription = _player.mediaItem.stream.listen(episodeChangedListener);
    _durationChangedSubscription = _player.durationStream.stream.listen(onDurationChanged);
  }

  Future<void> stopListeningToEvents() async {
    await _streamSubscription?.cancel();
    await _currentPlayerSubscription?.cancel();
    await _remoteCommandSubscription?.cancel();
    await _playerStatusSubscription?.cancel();
    await _transferPlaybackSubscription?.cancel();
  }

  Future<void> stopListeningToPlayerEvents() async {
    await _playbackStateSubscription?.cancel();
    await _mediaItemSubscription?.cancel();
    await _durationChangedSubscription?.cancel();
  }

  void listenToEvents() {
    var serverCubit = getIt.get<ServerCubit>();
    _streamSubscription = serverCubit.playbackStream.stream.where((e) => e.newPlayback ?? false).listen(onNewPlayback);
    _remoteCommandSubscription = serverCubit.remoteCommandsStream.stream.listen(_handleRemoteCommand);
    _playerStatusSubscription = serverCubit.playerStatusStream.stream.listen(_handleRemotePlayerStatus);
    _transferPlaybackSubscription = serverCubit.transferPlaybackStream.stream.listen(_handleTransferPlayback);
    _currentPlayerSubscription = serverCubit.currentPlayerStream.stream.listen((event) {
      emit(state.copyWith(currentPlayer: event));
    });
  }

  void _handleRemoteCommand(RemoteCommand command) {
    switch (command.type) {
      case .play:
        playPause();
        break;
      case .pause:
        playPause();
        break;
      case .stop:
        stop();
        break;
      case .rewind:
        skip(-10);
        break;
      case .skipForward:
        skip(30);
        break;
      case .seek:
        if (command.position != null) {
          seek(Duration(seconds: command.position!));
        }
      case .setSpeed:
        if (command.speed != null) {
          setSpeed(command.speed!);
        }
      case .setEpisode:
        if (command.episode != null) {
          playEpisode(command.episode!);
        }
        break;
      case .setVolume:
        if (command.volume != null) {
          setVolume(command.volume!, onChangeEnd: true);
        }
    }
  }

  void _handleRemotePlayerStatus(PlayerStatus playerStatus) {
    if (playerStatus.client?.id != sessionId) {
      if (playerStatus.episode == null) {
        _log.fine("Received null episode from remote player, closing");
        emit(
          state.copyWith(
            showMiniPlayer: false,
            showBigPlayer: false,
            episode: null,
            position: .zero,
            bufferPosition: .zero,
            duration: .zero,
            playing: false,
            speed: 1,
            volume: 100,
          ),
        );
      } else {
        bool shouldShowPlayer = !state.showBigPlayer && !state.showMiniPlayer;

        emit(
          state.copyWith(
            episode: playerStatus.episode,
            playing: playerStatus.playing,
            position: Duration(seconds: playerStatus.position),
            duration: Duration(seconds: playerStatus.duration),
            showMiniPlayer: shouldShowPlayer ? false : state.showMiniPlayer,
            showBigPlayer: shouldShowPlayer ? true : state.showBigPlayer,
            speed: playerStatus.speed,
            volume: state.draggingVolume ? state.volume : playerStatus.volume,
          ),
        );
      }
      // this is a remote player we should display the player
    }
  }

  bool get isPlayingLocally => state.currentPlayer?.id == null || state.currentPlayer?.id == sessionId;

  @override
  void didChangeMetrics() {
    final oldBreakPoint = _currentBreakPoint;

    var view = PlatformDispatcher.instance.views.first;
    _currentBreakPoint = BreakPoint.getFromSize((view.physicalSize / view.devicePixelRatio).width);

    // when we go from mobile to bigger, we need to switch to big player
    if (oldBreakPoint != _currentBreakPoint &&
        (oldBreakPoint == .mobile || oldBreakPoint == .tablet) &&
        state.showMiniPlayer) {
      emit(state.copyWith(showBigPlayer: true, showMiniPlayer: false));
    }

    handleBackButton(state.showBigPlayer);
  }

  PodkuAudioHandler get _player => getIt.get<PodkuAudioHandler>();

  Future<void> playEpisode(
    Episode episode, {
    bool offline = false,
    Duration? initialPosition,
    bool fromTransfer = false,
  }) async {
    if (!fromTransfer && !isPlayingLocally) {
      _sendRemoteCommand(type: .setEpisode, episode: episode, position: initialPosition?.inSeconds ?? 0);
    } else {
      try {
        if (!fromTransfer && (state.episode != null && state.episode?.id == episode.id)) {
          if (state.episode?.id == episode.id) {
            playPause();
          }
          return;
        }
        await stopListeningToPlayerEvents();

        _log.fine('Playing episode: ${episode.title}, offline? $offline, initial position: $initialPosition');

        emit(
          state.copyWith(
            loading: true,
            showMiniPlayer: false,
            showBigPlayer: true,
            showTranscript: false,
            volume: _player.getVolume() * 100,
          ),
        );
        var backendEpisode =
            (!kIsWeb && offline) ||
                episode.id ==
                    null // we're playing from a podcast we're not subscribed
            ? episode
            : await client.episodes.getEpisode(id: episode.id ?? '').then((value) => value.data);

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

          await _player.playEpisode(episode, initialPosition: initialPosition);
          emit(state.copyWith(loading: false));
          if (!offline && episode.podcast?.id != unsubbedPodcastUuid) {
            await client.episodes.startPlayback(
              playbackProgress: PlaybackProgress(
                episodeId: episode.id,
                newPlayback: true,
                progress: 0,
                player: sessionId,
              ),
            );
          }
          await _player.play();

          listenToPlayerEvents();
        }
      } catch (e, s) {
        _log.severe('Failed to play episode', e, s);
        emit(state.copyWith(error: e, stackTrace: s));
      }
    }
  }

  void _handleTransferPlayback(TransferPlayback event) {
    _log.fine('received player transfer event $event');
    if (isPlayingLocally) {
      _log.fine("playing locally");
      if (event.playerId == sessionId) {
        _log.fine("already playing, nothing to do");
        // in case we transfer from here to here
        return;
      }
      _log.fine('We stop playing');
      // we stop
      _player.stop();
    } else if (event.playerId == sessionId) {
      _log.fine("Starting playback from transfer");
      // we start
      playEpisode(event.episode, initialPosition: Duration(seconds: event.position), fromTransfer: true);
    }
  }

  void _sendRemoteCommand({required CommandType type, Episode? episode, int? position, double? speed, double? volume}) {
    getIt.get<ServerCubit>().socket?.send(
      jsonEncode(
        PodkuSocketMessage(
          message: RemoteCommand(
            type: type,
            episode: episode,
            speed: speed,
            position: position,
            volume: volume,
          ).toJson(),
          type: .remoteCommand,
        ),
      ),
    );
  }

  void initialPlaybackTransfer(String targetId) {
    if (state.episode != null) {
      PodkuSocketMessage message = PodkuSocketMessage(
        message: TransferPlayback(
          episode: state.episode!,
          position: state.position.inSeconds,
          playerId: targetId,
        ).toJson(),
        type: .transferPlayback,
      );
      getIt.get<ServerCubit>().socket?.send(jsonEncode(message));
    }
  }

  void playPause() {
    if (isPlayingLocally) {
      _player.playbackState.value.playing ? _player.pause() : _player.play();
    } else {
      _sendRemoteCommand(type: .pause);
    }
  }

  void showPlayers(bool miniPlayer, bool bigPlayer) {
    emit(state.copyWith(showMiniPlayer: miniPlayer, showBigPlayer: bigPlayer));
  }

  void skip(int seconds) {
    if (isPlayingLocally) {
      _player.seek(state.position + Duration(seconds: seconds));
    } else {
      _sendRemoteCommand(type: seconds > 0 ? .skipForward : .rewind);
    }
  }

  void seek(Duration duration) {
    if (isPlayingLocally) {
      _player.seek(duration);
    } else {
      _sendRemoteCommand(type: .seek, position: duration.inSeconds);
    }
  }

  Future<void> onStateChanged(PlaybackState event) async {
    bool sendSocketUpdate = false;
    if (event.playing != state.playing) {
      sendSocketUpdate = true;
    }
    emit(
      state.copyWith(
        playing: event.playing,
        position: event.position,
        bufferPosition: event.bufferedPosition,
        speed: event.speed,
        // volume: _player.getVolume() * 100,
      ),
    );
    // we only want to update when there's a change in play status here, otherwise we're going to flood the websocket
    if (sendSocketUpdate) {
      _sendCurrentState(true);
    }
    _updateProgress();
  }

  void _sendCurrentState(bool broadcast) {
    final status = PlayerStatus(
      episode: state.episode,
      position: state.position.inSeconds,
      duration: state.duration.inSeconds,
      playing: state.playing,
      speed: _player.playbackState.value.speed,
      volume: _player.getVolume() * 100,
      broadcast: broadcast,
    );
    final message = PodkuSocketMessage(message: status.toJson(), type: .playerStatus);
    getIt.get<ServerCubit>().socket?.send(jsonEncode(message));
  }

  void _updateProgress() {
    if (state.episode?.podcast?.id != unsubbedPodcastUuid && !state.loading && state.episode != null) {
      final episode = state.episode!;
      final progress = state.position;
      final duration = state.duration;

      if (progress == duration) {
        stop();
      }

      EasyThrottle.throttle('progress-update-${episode.id}', Duration(seconds: 5), () async {
        await _updateProgressInner(episode, progress, duration);
      });
      // we do this so that whenever the episode stops playing, we save one last time
      EasyDebounce.debounce('progress-update-debounce-${episode.id}', Duration(seconds: 2), () async {
        await _updateProgressInner(episode, progress, duration, broadcast: false);
        if (!kIsWeb) {
          await getIt.get<DownloadManagerCubit>().getOfflineEpisodes();
        }
      });
    }
  }

  Future<void> _updateProgressInner(
    Episode episode,
    Duration progress,
    Duration totalDuration, {
    bool broadcast = true,
  }) async {
    if (isOnline) {
      try {
        _sendCurrentState(broadcast);
      } catch (e) {
        _log.warning("Could not update episode progress", e);
      }
    }

    try {
      if (await episode.validOfflineFiles) {
        final directory = await episode.episodeFolder(createIfMissing: true);

        final File data = File(p.join(directory.path, EpisodeDownloads.data));
        await data.writeAsString(jsonEncode(episode.copyWith(progress: progress.inSeconds.toDouble()).toJson()));
      }
    } catch (e) {
      _log.warning('Failed to update progress on downloaded podcast', e);
    }

    // we write to our "offline progress buffer"
    // so if we're playing while offline, next time we connect, we will send to the backend
    if (episode.id != null) {
      OfflineProgressSaver.updateProgress(episodeId: episode.id!, progress: progress.inSeconds);
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
    if (isPlayingLocally) {
      _player.stop();
    } else {
      _sendRemoteCommand(type: .stop);
    }
  }

  Future<void> episodeChangedListener(MediaItem? event) async {
    if (event != null) {
      final episode =
          (!kIsWeb
              ? getIt.get<DownloadManagerCubit>().state.offlineEpisodes.where((e) => e.id == event.id).firstOrNull
              : null) ??
          await client.episodes.getEpisode(id: event.id).then((value) => value.data);

      if (episode != null) {
        emit(state.copyWith(episode: episode));
      }
      if (!state.showBigPlayer && !state.showMiniPlayer) {
        emit(state.copyWith(showBigPlayer: true));
      }

      _sendCurrentState(true);
    }
  }

  /// when a client starts playing what we're playing we stop here
  void onNewPlayback(PlaybackProgress event) {
    _log.fine('Received new playback event: $event');
    if (event.episodeId == state.episode?.id) {
      stop();
    }
  }

  void setSpeed(double speed) {
    if (isPlayingLocally) {
      _player.setSpeed(speed);
    } else {
      _sendRemoteCommand(type: .setSpeed, speed: speed);
    }
  }

  Future<void> setVolume(double volume, {required bool onChangeEnd}) async {
    _log.fine('Setting volume to $volume');
    emit(state.copyWith(volume: volume, draggingVolume: !onChangeEnd));
    if (isPlayingLocally) {
      await _player.setVolume(volume);
      _sendCurrentState(true);
    } else if (onChangeEnd) {
      // if we're playing remotely, no need to flood the network and just change volume when the drag is over
      _sendRemoteCommand(type: .setVolume, volume: volume);
    }
  }

  void onDurationChanged(Duration event) {
    _log.fine('Duration changed: $event');
    emit(state.copyWith(duration: event));
  }

  void showTranscript(bool show) {
    emit(state.copyWith(showTranscript: show, showVolume: show ? false : state.showVolume));
  }

  void setShowVolume(bool showVolume) {
    emit(state.copyWith(showVolume: showVolume, showTranscript: showVolume ? false : state.showTranscript));
  }

  void setCurrentPlayer(PlayerInfo? currentPlayer) {
    emit(state.copyWith(currentPlayer: currentPlayer));
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
    @Default(1) double speed,
    @Default(false) bool playing,
    @Default(false) bool showMiniPlayer,
    @Default(false) bool showBigPlayer,
    @Default(false) bool showTranscript,
    @Default(false) bool showVolume,
    @Default(false) bool draggingVolume,
    @Default(1) double volume,
    PlayerInfo? currentPlayer,
    dynamic error,
    StackTrace? stackTrace,
  }) = _PlayerState;
}
