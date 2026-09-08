import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nock/nock.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/server/client/client.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String testServerUrl = 'http://localhost:8080';

class TestServerCubit extends ServerCubit {
  TestServerCubit(super.initialState);

  @override
  Future<void> init() async {
    // No-op for tests: prevents unwanted web socket and timer connections
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {}

  @override
  Future<bool> setServerUrl(String? serverUrl, {bool testServer = true}) async {
    emit(state.copyWith(loading: true));
    try {
      if (serverUrl != null && serverUrl.startsWith('http')) {
        if (serverUrl.endsWith('/')) {
          serverUrl = serverUrl.substring(0, serverUrl.length - 1);
        }
        final client = Client(serverUrl);
        if (testServer) {
          await client.podcasts.getPodcasts();
        }
        emit(state.copyWith(
          client: client,
          serverUrl: serverUrl,
          initialized: true,
          status: InternetConnectionStatus.connected,
        ));
        return true;
      } else {
        emit(state.copyWith(
          status: InternetConnectionStatus.disconnected,
          client: null,
          serverUrl: null,
          initialized: false,
        ));
        return false;
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, serverUrl: null, initialized: false));
      return false;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}

void setupTestGetIt({String serverUrl = testServerUrl}) {
  TestWidgetsFlutterBinding.ensureInitialized();
  nock.init();
  SharedPreferences.setMockInitialValues({'serverUrl': serverUrl});

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async => '.',
  );

  if (getIt.isRegistered<ServerCubit>()) {
    getIt.unregister<ServerCubit>();
  }

  final client = Client(serverUrl);
  final serverCubit = TestServerCubit(
    ServerState(
      serverUrl: serverUrl,
      client: client,
      initialized: true,
      status: InternetConnectionStatus.connected,
    ),
  );
  getIt.registerSingleton<ServerCubit>(serverCubit);
}

class FakePlayerCubit extends Cubit<PlayerState> implements PlayerCubit {
  FakePlayerCubit([PlayerState? state]) : super(state ?? const PlayerState());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeDownloadManagerCubit extends Cubit<DownloadManagerState>
    implements DownloadManagerCubit {
  FakeDownloadManagerCubit([DownloadManagerState? state])
      : super(state ?? const DownloadManagerState());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget wrapWithMaterial({
  required Widget child,
  Size? size,
  PlayerCubit? playerCubit,
  ServerCubit? serverCubit,
  DownloadManagerCubit? downloadManagerCubit,
}) {
  Widget content = Scaffold(
    body: size != null
        ? SizedBox(width: size.width, height: size.height, child: child)
        : child,
  );

  if (downloadManagerCubit != null) {
    content = BlocProvider<DownloadManagerCubit>.value(
      value: downloadManagerCubit,
      child: content,
    );
  }

  if (playerCubit != null) {
    content = BlocProvider<PlayerCubit>.value(
      value: playerCubit,
      child: content,
    );
  }

  if (serverCubit != null) {
    content = BlocProvider<ServerCubit>.value(
      value: serverCubit,
      child: content,
    );
  }

  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1b3a3a)),
    ),
    home: content,
  );
}

Map<String, dynamic> createMockPodcastLightJson({
  String id = '123e4567-e89b-12d3-a456-426614174000',
  String name = 'Tech Talk Daily',
  String url = 'http://example.com/feed.xml',
  String artworkUrl = 'http://example.com/art.png',
  String description = 'A daily technology podcast discussing software.',
}) {
  return {
    'id': id,
    'name': name,
    'url': url,
    'artworkUrl': artworkUrl,
    'description': description,
    'author': 'Podku Team',
    'link': 'http://example.com',
  };
}

Map<String, dynamic> createMockEpisodeJson({
  String id = '223e4567-e89b-12d3-a456-426614174001',
  String title = 'Episode 1: Architecture Deep Dive',
  String description = 'Detailed look into Podku system design.',
  int pubDateMillis = 1704067200000,
  int durationSeconds = 1800,
  double progress = 0.0,
}) {
  return {
    'id': id,
    'title': title,
    'description': description,
    'pubDateMillis': pubDateMillis,
    'durationSeconds': durationSeconds,
    'explicit': false,
    'progress': progress,
    'processed': true,
    'podcast': createMockPodcastLightJson(),
  };
}

Map<String, dynamic> createMockBookmarkWithTranscriptJson({
  String bookmarkId = '323e4567-e89b-12d3-a456-426614174002',
  int timeSeconds = 120,
  String topic = 'System Architecture Overview',
  String transcriptContent = 'Here we explain how the backend communicates with the Flutter client.',
}) {
  return {
    'bookmark': {
      'id': bookmarkId,
      'time': timeSeconds,
      'topic': topic,
      'episode': createMockEpisodeJson(),
    },
    'transcripts': {
      'en': [
        {
          'id': '423e4567-e89b-12d3-a456-426614174003',
          'startTime': '00:02:00.000',
          'endTime': '00:02:15.000',
          'speaker': 'Alice',
          'content': transcriptContent,
          'language': 'en',
        }
      ]
    }
  };
}
