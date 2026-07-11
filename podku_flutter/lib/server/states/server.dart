import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_client/podku_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'server.freezed.dart';

final RegExp _urlRegex = RegExp(r'http.+');

class ServerCubit extends Cubit<ServerState> {
  Client? client;
  final TextEditingController controller = TextEditingController();

  ServerCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    String? serverUrl;
    if (kIsWeb) {
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

  Future<bool> setServerUrl(String? serverUrl) async {
    try {
      emit(state.copyWith(serverUrl: serverUrl));
      if (serverUrl != null && _urlRegex.hasMatch(serverUrl)) {
        if (serverUrl.endsWith('/')) {
          serverUrl = serverUrl.substring(0, serverUrl.length - 1);
        }

        if (!kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("serverUrl", serverUrl);
        }
        client = Client(state.apiUrl)
          ..connectivityMonitor = FlutterConnectivityMonitor()
          ..authSessionManager = FlutterAuthSessionManager();

        client?.auth.initialize();
        emit(state.copyWith(initialized: true));
        return true;
      } else {
        if (!kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove("serverUrl");
        }
        emit(state.copyWith(initialized: true));
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}

@freezed
sealed class ServerState with _$ServerState {
  const factory ServerState({
    String? serverUrl,
    @Default(false) initialized,
  }) = _ServerState;

  const ServerState._();

  String get apiUrl => '$serverUrl/api';
}
