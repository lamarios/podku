import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nock/nock.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/server/views/screens/setup.dart';
import 'package:snaptest/snaptest.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  testWidgets('ServerSetupScreen renders setup UI and responds to input', (tester) async {
    final serverCubit = TestServerCubit(const ServerState());

    final router = GoRouter(
      initialLocation: '/setup',
      routes: [
        GoRoute(
          path: '/setup',
          builder: (context, state) => BlocProvider<ServerCubit>.value(
            value: serverCubit,
            child: const ServerSetupScreen(),
          ),
        ),
        GoRoute(
          path: '/home/episodes',
          builder: (context, state) => const Scaffold(body: Text('Home Episodes')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);

    // Golden screenshot of ServerSetupScreen
    await snap(name: 'server_setup_screen', matchToGolden: true);

    // Mock successful server connection verification
    nock('http://localhost:8080').get('/api/podcasts')
      .reply(
        200,
        jsonEncode([]),
        headers: {'content-type': 'application/json'},
      );

    await tester.enterText(find.byType(TextField), 'http://localhost:8080');
    await tester.pump();
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(serverCubit.state.serverUrl, 'http://localhost:8080');
    expect(serverCubit.state.initialized, isTrue);

    await serverCubit.close();
  });
}
