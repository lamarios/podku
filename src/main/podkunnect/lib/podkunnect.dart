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
  Player? _player;
  late final Client client;
  PlayerStatus? playbackStatus;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<bool>? _playingSubscription;

  ReconnectableWebSocket? socket;

  Podkunnect({required this.name, required this.serverUrl}) {
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

  void _handleSocketMessage(PodkuSocketMessage event) {
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
    await _player?.stop();
    await _player?.dispose();
    _player = null;
  }

  Future<void> startPlayback({required Episode episode, required int position}) async {
    _player ??= Player();
    _player?.open(Media(episode.audioProxyUrl(serverUrl), start: Duration(seconds: position)));

    playbackStatus = PlayerStatus(
      episode: episode,
      position: position,
      duration: episode.durationSeconds ?? 1,
      speed: 1,
      playing: true,
    );

    _broadcastStatus(playbackStatus);
    _playingSubscription = _player?.stream.playing.listen((event) {
      playbackStatus = playbackStatus?.copyWith(playing: event);
      _broadcastStatus(playbackStatus);
    });

    _positionSubscription = _player?.stream.position.listen((event) {
      playbackStatus = playbackStatus?.copyWith(position: event.inSeconds);
      final toBroadcast = playbackStatus?.copyWith();
      EasyThrottle.throttle('throttle-progress-update-${toBroadcast?.episode?.id}', Duration(seconds: 5), () {
        _broadcastStatus(toBroadcast);
      });
      EasyDebounce.debounce('progress-update-${toBroadcast?.episode?.id}', Duration(seconds: 2), () {
        _broadcastStatus(toBroadcast, broadcast: false);
      });
    });

    _durationSubscription = _player?.stream.duration.listen((event) {
      playbackStatus = playbackStatus?.copyWith(duration: event.inSeconds);
      _broadcastStatus(playbackStatus);
    });
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
      }

      final state = _player!.state;

      _broadcastStatus(
        playbackStatus?.copyWith(
          position: newPosition?.inSeconds ?? state.position.inSeconds,
          duration: state.duration.inSeconds,
          speed: state.rate,
          playing: state.playing,
        ),
      );
    }
  }

  Future<void> _playEpisode(Episode episode) async {
    Episode? backendEpisode;
    if (episode.id != null) {
      backendEpisode = await client.episodes.getEpisode(id: episode.id!).then((value) => value.data);
    }

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
    );

    _broadcastStatus(playbackStatus);
  }
}
