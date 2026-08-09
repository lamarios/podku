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
  StreamSubscription<PodkuSocketMessage>? _subscription;
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

    _subscription = socket?.controller.stream.listen((event) {
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

  void _broadcastStatus() {
    final message = PodkuSocketMessage(message: playbackStatus?.toJson(), type: .playerStatus);
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

    _broadcastStatus();
    _playingSubscription = _player?.stream.playing.listen((event) {
      playbackStatus = playbackStatus?.copyWith(playing: event);
      _broadcastStatus();
    });

    _positionSubscription = _player?.stream.position.listen((event) {
      playbackStatus = playbackStatus?.copyWith(position: event.inSeconds);
      EasyThrottle.throttle('throttle-progress-update', Duration(seconds: 5), () {
        _broadcastStatus();
      });
      EasyDebounce.debounce('progress-update', Duration(seconds: 2), () {
        _broadcastStatus();
      });
    });

    _durationSubscription = _player?.stream.duration.listen((event) {
      playbackStatus = playbackStatus?.copyWith(duration: event.inSeconds);
      _broadcastStatus();
    });
  }

  Future<void> _handleRemoteCommand(RemoteCommand remoteCommand) async {
    _log.info("Received remote command: ${remoteCommand.type}");
    switch (remoteCommand.type) {
      case .stop:
        await disposePlayer();
        playbackStatus = null;
        _broadcastStatus();
        break;
      case .seek:
        if (remoteCommand.position != null) {
          _player?.seek(Duration(seconds: remoteCommand.position!));
        }
        break;
      case .rewind:
        _player?.seek(_player!.state.position - Duration(seconds: 10));
        break;
      case .skipForward:
        _player?.seek(_player!.state.position + Duration(seconds: 30));
        break;
      case .pause:
      case .play:
        _player?.playOrPause();
        break;
      case .setSpeed:
        if (remoteCommand.speed != null) {
          _player?.setRate(remoteCommand.speed ?? 1);
        }
        break;
      case .setEpisode:
        if (remoteCommand.episode != null) {
          _playEpisode(remoteCommand.episode!);
        }
        break;
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

    _broadcastStatus();
  }
}
