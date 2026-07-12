import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/screens/podcasts.dart';
import 'package:podku/router.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

/// Sets up a global client object that can be used to talk to the server from
/// anywhere in our app. The client is generated from your server code
/// and is set up to connect to a Serverpod running on a local server on
/// the default port. You will need to modify this to connect to staging or
/// production servers.
/// In a larger app, you may want to use the dependency injection of your choice
/// instead of using a global client object. This is just a simple example.

Client get client => getIt.get<ServerCubit>().client!;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioHandler = await AudioService.init(builder: () => PodkuAudioHandler(), config: AudioServiceConfig(
    androidNotificationChannelId: 'com.github.lamarios.podku.audio',
    androidNotificationChannelName: 'Podku podcast'
  ));
  getIt.registerSingleton(audioHandler);

  final ServerCubit serverCubit = ServerCubit(ServerState());
  getIt.registerSingleton(serverCubit);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTheme = AppBarThemeData(scrolledUnderElevation: 0, surfaceTintColor: Colors.transparent);
    ColorScheme darkColorScheme = .fromSeed(
      seedColor: appColor,
      brightness: Brightness.dark,
    );
    ColorScheme lightColorScheme = .fromSeed(
      seedColor: appColor,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<ServerCubit>()),
        BlocProvider(
          create: (context) => PlayerCubit(PlayerState()),
        ),
      ],
      child: BlocBuilder<ServerCubit, ServerState>(
        builder: (context, state) {
          return state.initialized
              ? MaterialApp.router(
                  routerConfig: router(state.serverUrl),
                  darkTheme: ThemeData(
                    colorScheme: darkColorScheme,
                    appBarTheme: appBarTheme.copyWith(backgroundColor: darkColorScheme.surface),
                  ),
                  themeMode: MediaQuery.platformBrightnessOf(context) == .dark ? .dark : .light,
                  theme: ThemeData(
                    // This is the theme of your application.
                    //
                    // TRY THIS: Try running your application with "flutter run". You'll see
                    // the application has a purple toolbar. Then, without quitting the app,
                    // try changing the seedColor in the colorScheme below to Colors.green
                    // and then invoke "hot reload" (save your changes or press the "hot
                    // reload" button in a Flutter-supported IDE, or press "r" if you used
                    // the command line to start the app).
                    //
                    // Notice that the counter didn't reset back to zero; the application
                    // state is not lost during the reload. To reset the state, use hot
                    // restart instead.
                    //
                    // This works for code too, not just values: Most code changes can be
                    // tested with just a hot reload.
                    colorScheme: lightColorScheme,
                    appBarTheme: appBarTheme.copyWith(backgroundColor: lightColorScheme.surface),
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const PodcastsScreen(),
      // To test authentication in this example app, uncomment the line below
      // and comment out the line above. This wraps the GreetingsScreen with a
      // SignInScreen, which automatically shows a sign-in UI when the user is
      // not authenticated and displays the GreetingsScreen once they sign in.
      //
      // body: SignInScreen(
      //   child: GreetingsScreen(
      //     onSignOut: () async {
      //       await client.auth.signOutDevice();
      //     },
      //   ),
      // ),
    );
  }
}
