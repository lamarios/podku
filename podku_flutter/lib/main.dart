import 'package:audio_service/audio_service.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logging/logging.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/router.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/colors.dart';
import 'package:podku_client/podku_client.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.

Client get client => getIt.get<ServerCubit>().state.client!;
InternetConnectionStatus get connectionStatus => getIt.get<ServerCubit>().state.status;
bool get isOnline => connectionStatus == .connected || connectionStatus == .slow;

late final GoRouter _router;
final sessionId = Uuid().v4obj();

void main() async {
  Logger.root.level = kDebugMode ? Level.FINEST : Level.INFO;
  Logger.root.onRecord.listen((record) {
    debugPrint('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrintStack(stackTrace: record.stackTrace);
    }
  });

  WidgetsFlutterBinding.ensureInitialized();

  final audioHandler = await AudioService.init(
    builder: () => PodkuAudioHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.github.lamarios.podku.audio',
      androidNotificationChannelName: 'Podku podcast',
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidBrowsableRootExtras: {
        'android.media.browse.CONTENT_STYLE_BROWSABLE_HINT': 2, // grid
        'android.media.browse.CONTENT_STYLE_PLAYABLE_HINT': 1, // list
      },
    ),
  );
  getIt.registerSingleton(audioHandler);

  final ServerCubit serverCubit = ServerCubit(ServerState());
  getIt.registerSingleton(serverCubit);
  _router = router(serverCubit);

  if (!kIsWeb) {
    final downloadManager = DownloadManagerCubit(DownloadManagerState());
    getIt.registerSingleton(downloadManager);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTheme = AppBarThemeData(scrolledUnderElevation: 0, surfaceTintColor: Colors.transparent);
    final tabTheme = TabBarThemeData(dividerColor: Colors.transparent);
    ColorScheme darkColorScheme = .fromSeed(seedColor: appColor, brightness: Brightness.dark);
    ColorScheme lightColorScheme = .fromSeed(seedColor: appColor);
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        darkColorScheme = darkDynamic?.copyWith(surface: darken(darkDynamic.surface, 0.3)) ?? darkColorScheme;
        lightColorScheme = lightDynamic?.copyWith(surface: lighten(lightDynamic.surface, 0.3)) ?? lightColorScheme;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt.get<ServerCubit>()),
            BlocProvider(create: (context) => PlayerCubit(PlayerState())),
            if (!kIsWeb) BlocProvider(create: (context) => getIt.get<DownloadManagerCubit>()),
          ],

          child: MaterialApp.router(
            routerConfig: _router,
            debugShowCheckedModeBanner: kDebugMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              appBarTheme: appBarTheme.copyWith(backgroundColor: darkColorScheme.surface),
              tabBarTheme: tabTheme,
            ),
            themeMode: MediaQuery.platformBrightnessOf(context) == .dark ? .dark : .light,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              appBarTheme: appBarTheme.copyWith(backgroundColor: lightColorScheme.surface),
              tabBarTheme: tabTheme,
            ),
          ),
        );
      },
    );
  }
}
