import 'dart:async';
import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logging/logging.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/offline_episodes/utils.dart';
import 'package:podku/server/client/client.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_shared/podku_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'server.freezed.dart';

final RegExp _urlRegex = RegExp(r'http.+');
final _log = Logger('ServerCubit');

class ServerCubit extends Cubit<ServerState> with WidgetsBindingObserver {
  final StreamController<PlaybackProgress> playbackStream = StreamController.broadcast();
  final StreamController<RemoteCommand> remoteCommandsStream = StreamController.broadcast();
  final StreamController<PlayerStatus> playerStatusStream = StreamController.broadcast();
  final StreamController<TransferPlayback> transferPlaybackStream = StreamController.broadcast();
  final StreamController<PlayerInfo?> currentPlayerStream = StreamController.broadcast();
  final TextEditingController controller = TextEditingController();
  StreamSubscription<PodkuSocketMessage>? _subscription;

  ReconnectableWebSocket? socket;
  InternetConnectionChecker? connectionChecker;

  ServerCubit(super.initialState) {
    init();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> init() async {
    String? serverUrl;
    if (kIsWeb && !kDebugMode) {
      Uri base = Uri.base;
      serverUrl = '${base.scheme}://${base.host}';

      if (base.port != 80 && base.port != 443) {
        serverUrl += ':${base.port}';
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      serverUrl = prefs.getString("serverUrl");
      if (serverUrl != null) {
        emit(state.copyWith(serverUrl: serverUrl));
      }
    }

    await setServerUrl(serverUrl, testServer: false);
  }

  Future<Client?> waitForClientToBeSet() async {
    if (state.client == null) {
      try {
        _log.fine('Waiting for client to be set');
        return await stream.map((event) => event.client).firstWhere((c) => c != null).timeout(Duration(seconds: 10));
      } on TimeoutException {
        _log.fine('app not ready yet, client is missing. stopping here...');
        return null;
      }
    } else {
      return state.client;
    }
  }

  Future<bool> setServerUrl(String? serverUrl, {bool testServer = true}) async {
    emit(state.copyWith(loading: true));
    try {
      if (serverUrl != null && _urlRegex.hasMatch(serverUrl)) {
        if (serverUrl.endsWith('/')) {
          serverUrl = serverUrl.substring(0, serverUrl.length - 1);
        }

        // if (!kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("serverUrl", serverUrl);
        // }

        final client = Client(serverUrl);

        try {
          if (testServer) {
            await client.podcasts.getPodcasts();
          }
          emit(state.copyWith(client: client, serverUrl: serverUrl, initialized: true, status: .connected));
          _subscribeToStream(client);
          _watchConnectionStatus(serverUrl);
          return true;
        } catch (e, s) {
          _log.fine("could not connect to server $serverUrl", e);
          emit(state.copyWith(error: e, stackTrace: s, serverUrl: null, initialized: false));
          _stopWatchConnectionStatus();
          return false;
        }
      } else {
        _disconnectFromStream();
        // if (!kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("serverUrl");
        emit(state.copyWith(status: .disconnected, client: null, serverUrl: null, initialized: false));
        // }
        _stopWatchConnectionStatus();
        return false;
      }
    } catch (e, s) {
      _log.severe(e, s);
      _stopWatchConnectionStatus();
      return false;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void _handleSocketMessage(PodkuSocketMessage message) {
    switch (message.type) {
      case .remoteCommand:
        if (message.message == null) {
          return;
        }
        final remoteCommand = RemoteCommand.fromJson(message.message!);
        _log.fine("Received remote command $remoteCommand}");
        remoteCommandsStream.add(remoteCommand);
        break;
      case .clientList:
        if (message.message == null) {
          return;
        }
        final event = ClientList.fromJson(message.message!);
        final clients = List<PlayerInfo>.from(event.clients);

        currentPlayerStream.add(event.currentPlayer);

        clients.sort((a, b) {
          if (a.id == sessionId) {
            return -1;
          } else if (b.id == sessionId) {
            return 1;
          } else {
            return a.name.compareTo(b.name);
          }
        });

        _log.fine('Received client list: $clients');

        emit(state.copyWith(clients: clients));
        break;
      case .playerStatus:
        if (message.message == null) {
          _log.fine("Received null message, assuming the remote player closed its stream");
          playerStatusStream.add(PlayerStatus(episode: null, position: 0, duration: 1, playing: false, speed: 1));
        } else {
          playerStatusStream.add(PlayerStatus.fromJson(message.message!));
        }
        break;
      case .transferPlayback:
        if (message.message != null) {
          transferPlaybackStream.add(TransferPlayback.fromJson(message.message!));
        }
        break;
      default:
        _log.fine('Unhandled message, $message');
    }
  }

  Future<void> _subscribeToStream(Client client) async {
    EasyDebounce.debounce('websocket-connection', Duration(seconds: 1), () async {
      if (socket != null && socket!.isConnected) {
        _log.fine('Already connected to socket');
        return;
      }

      _log.fine('Attempt to connect to socket');
      try {
        await _disconnectFromStream().timeout(Duration(seconds: 2));
      } catch (e) {
        _log.fine('failed to close socket connection, we move on');
        socket = null;
      }
      _log.fine('existing connection closed');
      socket = ReconnectableWebSocket(uri: Uri.parse('${state.serverUrl}/ws'.replaceFirst('http', 'ws')));
      _log.fine('socket: ${socket?.uri}');
      socket?.onConnected = () {
        // not really related to the websocket but we catch up in case we played episodes offline
        OfflineProgressSaver.sendProgressToBackend();

        _log.fine('Connected, sending device info');
        final message = PodkuSocketMessage(
          message: PlayerInfo(id: sessionId, name: deviceName).toJson(),
          type: .playerInfo,
        );
        _log.fine("Sending device info");
        // sending player info
        socket?.send(jsonEncode(message));
      };

      _log.fine('subscribing to stream');
      _subscription = socket?.controller.stream.listen((event) {
        _handleSocketMessage(event);
      });

      _log.fine('Connecting...');
      await socket?.connect();
      _log.fine('Connection complete');
    });
  }

  Future<void> _disconnectFromStream() async {
    _log.fine('Disconnecting froms websocket');
    emit(state.copyWith(clients: []));
    await _subscription?.cancel();
    await socket?.close();
    socket = null;
  }

  @override
  Future<void> close() async {
    _stopWatchConnectionStatus();
    await _disconnectFromStream();
    return super.close();
  }

  void onConnectionChange(InternetConnectionStatus event) {
    _log.fine('Connection state:  $event');
    if (event == .disconnected) {
      _disconnectFromStream();
    } else {
      _subscribeToStream(state.client!);
    }
    emit(state.copyWith(status: event));
  }

  void _watchConnectionStatus(String serverUrl) {
    _log.fine('Watching connection status');
    connectionChecker?.dispose();
    connectionChecker = InternetConnectionChecker.createInstance(
      addresses: [AddressCheckOption(uri: Uri.parse('$serverUrl/api/ping'))],
      slowConnectionConfig: SlowConnectionConfig(
        enableToCheckForSlowConnection: true,
        slowConnectionThreshold: Duration(seconds: 1),
      ),
    );
    connectionChecker?.onStatusChange.listen(onConnectionChange);
  }

  void _stopWatchConnectionStatus() {
    connectionChecker?.dispose();
    connectionChecker = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    _log.fine('AppState: $appState');
    if (state.serverUrl != null && appState == AppLifecycleState.resumed) {
      _watchConnectionStatus(state.serverUrl!);
    } else {
      _stopWatchConnectionStatus();
    }
  }
}

@freezed
sealed class ServerState with _$ServerState implements WithError {
  @Implements<WithError>()
  const factory ServerState({
    String? serverUrl,
    @Default(false) initialized,
    Client? client,
    StackTrace? stackTrace,
    @Default(false) bool loading,
    @Default([]) List<PlayerInfo> clients,
    dynamic error,
    @Default(InternetConnectionStatus.connected) InternetConnectionStatus status,
  }) = _ServerState;

  const ServerState._();

  String get apiUrl => '$serverUrl/api';
}
