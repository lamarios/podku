import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:nock/nock.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/states/continue_playing.dart';
import 'package:podku/episodes/views/components/continue_playing.dart';
import 'package:podku/episodes/views/components/episode_in_continue_playing.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/server/states/server.dart';
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

  void mockInProgress(List<Map<String, dynamic>> episodes) {
    nock(testServerUrl).get(startsWith('/api/episodes/inProgress'))
      .reply(
        200,
        jsonEncode(episodes),
        headers: {'content-type': 'application/json'},
      );
  }

  Future<ContinuePlayingCubit> pumpContinuePlaying(
    WidgetTester tester, {
    Size screenSize = const Size(400, 300),
    PlayerCubit? playerCubit,
  }) async {
    tester.view.physicalSize = screenSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = ContinuePlayingCubit(const ContinuePlayingState());
    addTearDown(cubit.close);

    await tester.pumpWidget(
      wrapWithMaterial(
        playerCubit: playerCubit ?? FakePlayerCubit(),
        serverCubit: TestServerCubit(const ServerState()),
        downloadManagerCubit: FakeDownloadManagerCubit(),
        child: BlocProvider.value(
          value: cubit,
          child: const Padding(padding: EdgeInsets.all(12), child: ContinuePlaying()),
        ),
      ),
    );
    return cubit;
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pumpAndSettle();
    // Let CacheStore cleanup timer of the podcast images elapse
    await tester.pump(const Duration(seconds: 15));
  }

  testWidgets('ContinuePlaying shows a loading indicator while fetching', (tester) async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    await pumpContinuePlaying(tester);

    expect(find.byType(LoadingIndicator), findsOneWidget);
    expect(find.text('Continue listening'), findsNothing);

    await settle(tester);

    expect(find.byType(LoadingIndicator), findsNothing);
  });

  testWidgets('ContinuePlaying renders nothing when there are no in progress episodes', (tester) async {
    mockInProgress([]);

    await pumpContinuePlaying(tester);
    await settle(tester);

    expect(find.text('Continue listening'), findsNothing);
    expect(find.byType(EpisodeInContinuePlaying), findsNothing);
    expect(find.byType(LoadingIndicator), findsNothing);
  });

  testWidgets('ContinuePlaying renders in progress episodes', (tester) async {
    mockInProgress([
      createMockEpisodeJson(id: 'ep-1', title: 'Episode One', progress: 120),
      createMockEpisodeJson(id: 'ep-2', title: 'Episode Two', progress: 600),
    ]);

    await pumpContinuePlaying(tester);
    await settle(tester);

    expect(find.text('Continue listening'), findsOneWidget);
    expect(find.byType(EpisodeInContinuePlaying), findsNWidgets(2));
    expect(find.text('Episode One'), findsOneWidget);
    // horizontal list, second card is built but off screen on mobile
    expect(find.text('Episode Two', skipOffstage: false), findsOneWidget);

    await snap(name: 'continue_playing_list', matchToGolden: true);
  });

  testWidgets('ContinuePlaying shows the error as a snack when loading fails', (tester) async {
    nock(testServerUrl).get(startsWith('/api/episodes/inProgress')).reply(500, 'Internal Server Error');

    await pumpContinuePlaying(tester);
    await settle(tester);

    expect(find.byType(LoadingIndicator), findsNothing);
    expect(find.text('Continue listening'), findsNothing);
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('ContinuePlaying keeps episodes visible when a refresh fails', (tester) async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    final cubit = await pumpContinuePlaying(tester);
    await settle(tester);
    expect(find.byType(SnackBar), findsNothing);

    nock(testServerUrl).get(startsWith('/api/episodes/inProgress')).reply(500, 'Internal Server Error');
    final refresh = cubit.getEpisodes(loading: false);
    await settle(tester);
    await refresh;
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Episode One'), findsOneWidget);
  });

  testWidgets('ContinuePlaying keeps content visible on silent refresh', (tester) async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    final cubit = await pumpContinuePlaying(tester);
    await settle(tester);
    expect(find.byType(EpisodeInContinuePlaying), findsOneWidget);

    mockInProgress([
      createMockEpisodeJson(id: 'ep-1', title: 'Episode One'),
      createMockEpisodeJson(id: 'ep-2', title: 'Episode Two'),
    ]);
    final refresh = cubit.getEpisodes(loading: false);
    await tester.pump();

    expect(find.byType(LoadingIndicator), findsNothing);
    expect(find.text('Episode One'), findsOneWidget);

    await settle(tester);
    await refresh;

    expect(find.byType(EpisodeInContinuePlaying, skipOffstage: false), findsNWidgets(2));
  });

  testWidgets('EpisodeInContinuePlaying takes 75% of the width on mobile', (tester) async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    await pumpContinuePlaying(tester, screenSize: const Size(400, 300));
    await settle(tester);

    expect(tester.getSize(find.byType(EpisodeInContinuePlaying)).width, 300);
  });

  testWidgets('EpisodeInContinuePlaying has a fixed width on larger screens', (tester) async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    await pumpContinuePlaying(tester, screenSize: const Size(1000, 300));
    await settle(tester);

    expect(tester.getSize(find.byType(EpisodeInContinuePlaying)).width, 400);
  });

  testWidgets('EpisodeInContinuePlaying shows pause icon for the playing episode', (tester) async {
    mockInProgress([
      createMockEpisodeJson(id: 'ep-1', title: 'Episode One'),
      createMockEpisodeJson(id: 'ep-2', title: 'Episode Two'),
    ]);

    final playingEpisode = Episode(
      id: 'ep-1',
      title: 'Episode One',
      podcast: PodcastLight(id: '123e4567-e89b-12d3-a456-426614174000', name: 'Tech Talk Daily', url: ''),
    );

    await pumpContinuePlaying(
      tester,
      screenSize: const Size(1000, 300),
      playerCubit: FakePlayerCubit(
        PlayerState(episode: playingEpisode, playing: true, duration: const Duration(seconds: 1800)),
      ),
    );
    // the wavy progress indicator of the playing episode animates forever, pumpAndSettle would never return
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(const Duration(seconds: 15));

    double iconProgress(String title) {
      final card = find.ancestor(of: find.text(title), matching: find.byType(EpisodeInContinuePlaying));
      final icon = tester.widget<AnimatedIcon>(find.descendant(of: card, matching: find.byType(AnimatedIcon)));
      return icon.progress.value;
    }

    // play_pause animated icon: 1 = pause, 0 = play
    expect(iconProgress('Episode One'), 1);
    expect(iconProgress('Episode Two'), 0);
  });
}
