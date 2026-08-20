import 'dart:async';
import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:logging/logging.dart';
import 'package:media_kit/media_kit.dart';
import 'package:openapi/openapi.dart';
import 'package:podku_shared/podku_shared.dart';
import 'package:podkunnect/client.dart';
import 'package:podkunnect/models/episode_url.dart';
import 'package:uuid/uuid.dart';

class Podkunnect {
  static final String sessionId = Uuid().v4();
  static final _log = Logger('Podkunnect');
  final String name;
  final String serverUrl;
  final double volume;
  Player? _player;
  late final Client client;
  PlayerStatus? playbackStatus;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<double>? _volumeSubscription;

  ReconnectableWebSocket? socket;

  Podkunnect({required this.name, required this.serverUrl, this.volume = 100.0}) {
    client = Client(serverUrl);
    _subscribeToStream();
  }

  Future<void> _subscribeToStream() async {
    if (socket != null && socket!.isConnected) {
      _log.fine('Already connected to socket');
      return;
    }

    await socket?.close();

    socket = ReconnectableWebSocket(uri: Uri.parse('$serverUrl/ws'.replaceFirst('http', 'ws')));

    socket?.onConnected = () {
      final message = PodkuSocketMessage(
        message: PlayerInfo(id: sessionId, name: name).toJson(),
        type: .playerInfo,
      );
      _log.fine("Sending device info");
      // sending player info
      socket?.send(jsonEncode(message));
    };

    socket?.controller.stream.listen((event) {
      _handleSocketMessage(event);
    });

    await socket?.connect();
  }

  Future<void> _handleSocketMessage(PodkuSocketMessage event) async {
    switch (event.type) {
      case .transferPlayback:
        if (event.message != null) {
          _handlePlaybackTransfer(TransferPlayback.fromJson(event.message!));
        }
        break;
      case .remoteCommand:
        if (event.message != null) {
          _handleRemoteCommand(RemoteCommand.fromJson(event.message!));
        }
        break;
      case .clientList:
        // we return our current status
        final status =
            await _getCurrentPlayerStatus() ?? PlayerStatus(episode: null, position: 0, duration: 0, speed: 1);
        final message = PodkuSocketMessage(message: status.toJson(), type: .pong);
        socket?.send(jsonEncode(message));
        break;
      default:
        _log.fine('Received event of type ${event.type}');
    }
  }

  void _handlePlaybackTransfer(TransferPlayback transfer) {
    if (transfer.playerId == sessionId) {
      _log.info("Starting playback of episode ${transfer.episode.title}");
      startPlayback(episode: transfer.episode, position: transfer.position);
    } else {
      _log.info("Received request to stop the playback");
      disposePlayer();
    }
  }

  void _broadcastStatus(PlayerStatus? status, {bool broadcast = true}) {
    final message = PodkuSocketMessage(
      message: status?.copyWith(broadcast: broadcast, speed: _player?.state.rate ?? 1).toJson(),
      type: .playerStatus,
    );
    socket?.send(jsonEncode(message));
  }

  Future<void> disposePlayer() async {
    await _durationSubscription?.cancel();
    await _positionSubscription?.cancel();
    await _playingSubscription?.cancel();
    await _volumeSubscription?.cancel();
    await _player?.stop();
    await _player?.dispose();
    _player = null;
  }

  Future<void> startPlayback({required Episode episode, required int position}) async {
    // if we were already playing at a certain volume, we keep it
    final volume = _player?.state.volume ?? this.volume;
    _log.fine("Starting playback volume: $volume");
    _player ??= Player();
    _player?.setVolume(volume);
    _player?.open(Media(episode.audioProxyUrl(serverUrl), start: Duration(seconds: position)));

    playbackStatus = PlayerStatus(
      episode: episode,
      position: position,
      duration: episode.durationSeconds ?? 1,
      speed: 1,
      playing: true,
      volume: volume,
    );

    _broadcastStatus(playbackStatus);
    _playingSubscription = _player?.stream.playing.listen((event) async {
      final toBroadcast = await _getCurrentPlayerStatus();
      _broadcastStatus(toBroadcast);
    });

    _volumeSubscription = _player?.stream.volume.listen((event) async {
      final toBroadcast = await _getCurrentPlayerStatus();
      _broadcastStatus(toBroadcast);
    });
    _positionSubscription = _player?.stream.position.listen((event) async {
      playbackStatus = playbackStatus?.copyWith(position: event.inSeconds);
      final toBroadcast = await _getCurrentPlayerStatus();
      EasyThrottle.throttle('throttle-progress-update-${toBroadcast?.episode?.id}', Duration(seconds: 5), () {
        _broadcastStatus(toBroadcast);
      });
      EasyDebounce.debounce('progress-update-${toBroadcast?.episode?.id}', Duration(seconds: 2), () {
        _broadcastStatus(toBroadcast, broadcast: false);
      });
    });

    _durationSubscription = _player?.stream.duration.listen((event) async {
      final toBroadcast = await _getCurrentPlayerStatus();
      _broadcastStatus(toBroadcast);
    });
  }

  Future<PlayerStatus?> _getCurrentPlayerStatus() async {
    PlayerStatus? status;
    if (_player?.state != null && playbackStatus?.episode != null) {
      status = PlayerStatus(
        episode: playbackStatus!.episode,
        position: _player!.state.position.inSeconds,
        duration: _player!.state.duration.inSeconds,
        speed: _player!.state.rate,
        volume: _player!.state.volume,
        playing: _player!.state.playing,
      );
    } else {
      status = playbackStatus;
    }

    playbackStatus = status;
    return status;
  }

  Future<void> _handleRemoteCommand(RemoteCommand remoteCommand) async {
    if (_player != null) {
      _log.info("Received remote command: ${remoteCommand.type}");
      Duration? newPosition;
      switch (remoteCommand.type) {
        case .stop:
          await disposePlayer();
          playbackStatus = null;
          _broadcastStatus(null);
          return;
        case .seek:
          if (remoteCommand.position != null) {
            newPosition = Duration(seconds: remoteCommand.position!);
            await _player?.seek(Duration(seconds: remoteCommand.position!));
          }
          break;
        case .rewind:
          newPosition = _player!.state.position - Duration(seconds: 10);
          await _player?.seek(newPosition);
          break;
        case .skipForward:
          newPosition = _player!.state.position + Duration(seconds: 30);
          await _player?.seek(newPosition);
          break;
        case .pause:
        case .play:
          await _player?.playOrPause();
          break;
        case .setSpeed:
          if (remoteCommand.speed != null) {
            await _player?.setRate(remoteCommand.speed ?? 1);
          }
          break;
        case .setEpisode:
          if (remoteCommand.episode != null) {
            await _playEpisode(remoteCommand.episode!);
          }
          break;
        case .setVolume:
          if (remoteCommand.volume != null) {
            await _player?.setVolume(remoteCommand.volume!);
          }
      }

      final state = _player!.state;
      _log.fine('Current volume: ${state.volume}');
      _broadcastStatus(await _getCurrentPlayerStatus());
    }
  }

  Future<void> _playEpisode(Episode episode) async {
    Episode? backendEpisode;
    if (episode.id != null) {
      backendEpisode = await client.episodes.getEpisode(id: episode.id!).then((value) => value.data);
    }

    final volume = _player?.state.volume ?? this.volume;
    backendEpisode ??= episode;
    _player ??= Player();

    _player?.open(
      Media(backendEpisode.audioProxyUrl(serverUrl), start: Duration(seconds: backendEpisode.progress?.toInt() ?? 0)),
    );

    playbackStatus = PlayerStatus(
      episode: episode,
      position: backendEpisode.progress?.toInt() ?? 0,
      duration: episode.durationSeconds ?? 1,
      speed: 1,
      playing: true,
      volume: volume,
    );

    _broadcastStatus(playbackStatus);
  }
}
