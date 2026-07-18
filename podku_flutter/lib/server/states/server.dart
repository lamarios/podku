import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:podku/main.dart';
import 'package:podku_client/podku_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'server.freezed.dart';

final RegExp _urlRegex = RegExp(r'http.+');
final _log = Logger('ServerCubit');

class ServerCubit extends Cubit<ServerState> {
  final TextEditingController controller = TextEditingController();
  final StreamController<EpisodeProgress> playbackStream =
      StreamController.broadcast();
  StreamSubscription<EpisodeProgress>? _innerStream;

  ServerCubit(super.initialState) {
    init();
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
    }

    await setServerUrl(serverUrl);
  }

  Future<Client?> waitForClientToBeSet() async {
    if (state.client == null) {
      try {
        _log.fine('Waiting for client to be set');
        return await stream
            .map(
              (event) => event.client,
            )
            .firstWhere((c) => c != null)
            .timeout(Duration(seconds: 10));
      } on TimeoutException {
        _log.fine(
          'app not ready yet, client is missing. stopping here...',
        );
        return null;
      }
    } else {
      return state.client;
    }
  }

  Future<bool> setServerUrl(String? serverUrl) async {
    try {
      emit(state.copyWith(serverUrl: serverUrl));
      if (serverUrl != null && _urlRegex.hasMatch(serverUrl)) {
        if (serverUrl.endsWith('/')) {
          serverUrl = serverUrl.substring(0, serverUrl.length - 1);
        }

        // if (!kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("serverUrl", serverUrl);
        // }

        final client = Client(state.apiUrl)
          ..connectivityMonitor = FlutterConnectivityMonitor()
          ..authSessionManager = FlutterAuthSessionManager();

        await client.auth.initialize();

        emit(state.copyWith(client: client));

        _subscribeToStream(client);
        return true;
      } else {
        _disconnectFromStream();
        // if (!kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("serverUrl");
        emit(state.copyWith(client: null));
        // }
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      emit(state.copyWith(initialized: true));
    }
  }

  Future<void> _subscribeToStream(Client client) async {
    _innerStream = client.episodes
        .playbackStream(sessionId)
        .listen(
          (event) {
            _log.fine('Received new stream event: $event');
            playbackStream.add(event);
          },
        );

    _innerStream?.onError(
      (error) {
        _log.severe('Disconnected from playback stream', error);
        Future.delayed(
          Duration(seconds: 5),
          () => _subscribeToStream(client),
        );
      },
    );
  }

  Future<void> _disconnectFromStream() async {
    await _innerStream?.cancel();
  }

  @override
  Future<void> close() {
    controller.dispose();
    _disconnectFromStream();
    return super.close();
  }
}

@freezed
sealed class ServerState with _$ServerState {
  const factory ServerState({
    String? serverUrl,
    @Default(false) initialized,
    Client? client,
  }) = _ServerState;

  const ServerState._();

  String get apiUrl => '$serverUrl/api';
}
