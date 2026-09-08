import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_in_list.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/server/states/server.dart';
import 'package:snaptest/snaptest.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    setupTestGetIt();
  });

  testWidgets('EpisodeInList renders episode title, duration and play button', (tester) async {
    final episode = Episode(
      id: 'ep-test-1',
      title: 'Episode 10: Building with Flutter and Nix',
      durationSeconds: 2450,
      pubDateMillis: 1704067200000,
      explicit: false,
      progress: 600.0,
      processed: true,
      podcast: PodcastLight(
        id: 'pod-test-1',
        name: 'Podku Developer Podcast',
        url: 'http://example.com/feed.xml',
      ),
    );

    final playerCubit = FakePlayerCubit(const PlayerState());
    final serverCubit = TestServerCubit(const ServerState());
    final downloadCubit = FakeDownloadManagerCubit();

    await tester.pumpWidget(
      wrapWithMaterial(
        playerCubit: playerCubit,
        serverCubit: serverCubit,
        downloadManagerCubit: downloadCubit,
        size: const Size(450, 180),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: EpisodeInList(
            episode: episode,
            showPodcastImage: false,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Episode 10: Building with Flutter and Nix'), findsOneWidget);

    // Golden screenshot for this component
    await snap(name: 'episode_in_list_card', matchToGolden: true);
  });
}

