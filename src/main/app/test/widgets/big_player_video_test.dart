import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nock/nock.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/big_player.dart';
import 'package:podku/player/views/components/player_video.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

import '../test_helper.dart';

/// Player cubit with a given state, recording the video toggles.
class VideoPlayerCubit extends FakePlayerCubit {
  final bool playingLocally;
  int videoToggles = 0;

  VideoPlayerCubit(super.state, {this.playingLocally = true});

  @override
  bool get isPlayingLocally => playingLocally;

  @override
  void toggleVideo() => videoToggles++;
}

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
    if (getIt.isRegistered<PodkuAudioHandler>()) {
      getIt.unregister<PodkuAudioHandler>();
    }
    getIt.registerSingleton<PodkuAudioHandler>(FakeAudioHandler());
  });

  Future<VideoPlayerCubit> pumpBigPlayer(
    WidgetTester tester, {
    required List<Map<String, dynamic>> files,
    bool videoEnabled = false,
    bool showingVideo = false,
    bool playingLocally = true,
  }) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final episodeJson = createMockEpisodeJson(files: files);
    nock(testServerUrl)
        .get('/api/transcripts/${episodeJson['id']}/languages')
        .reply(200, jsonEncode([]), headers: {'content-type': 'application/json'});

    final cubit = VideoPlayerCubit(
      PlayerState(
        episode: Episode.fromJson(episodeJson),
        showBigPlayer: true,
        videoEnabled: videoEnabled,
        showingVideo: showingVideo,
        duration: const Duration(seconds: 1800),
      ),
      playingLocally: playingLocally,
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      wrapWithMaterial(
        playerCubit: cubit,
        serverCubit: TestServerCubit(const ServerState()),
        downloadManagerCubit: FakeDownloadManagerCubit(),
        child: const BigPlayer(),
      ),
    );
    // the podcast image animates forever while it is shown, the player can't settle
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return cubit;
  }

  Future<void> finish(WidgetTester tester) async {
    // Let the CacheStore cleanup timer of the podcast images elapse
    await tester.pump(const Duration(seconds: 15));
  }

  Finder toggleButton() => find.byWidgetPredicate(
    (w) => w is IconButton && (w.tooltip == 'Watch the video' || w.tooltip == 'Listen to the audio'),
  );

  group('audio / video toggle', () {
    testWidgets('offers to watch the video of an episode being listened to', (tester) async {
      await pumpBigPlayer(tester, files: [audioFileJson(), videoFileJson()]);

      expect(find.byTooltip('Watch the video'), findsOneWidget);
      expect(find.byIcon(Icons.videocam), findsOneWidget);
      await finish(tester);
    });

    testWidgets('offers to listen to the audio of an episode being watched', (tester) async {
      await pumpBigPlayer(tester, files: [audioFileJson(), videoFileJson()], videoEnabled: true, showingVideo: true);

      expect(find.byTooltip('Listen to the audio'), findsOneWidget);
      expect(find.byIcon(Icons.headphones), findsOneWidget);
      await finish(tester);
    });

    testWidgets('toggles the video when tapped', (tester) async {
      final cubit = await pumpBigPlayer(tester, files: [audioFileJson(), videoFileJson()]);

      await tester.tap(toggleButton());
      await tester.pump();

      expect(cubit.videoToggles, 1);
      await finish(tester);
    });

    testWidgets('is hidden for an audio only episode', (tester) async {
      await pumpBigPlayer(tester, files: [audioFileJson()]);

      expect(toggleButton(), findsNothing);
      await finish(tester);
    });

    testWidgets('is hidden for a video only episode', (tester) async {
      await pumpBigPlayer(tester, files: [videoFileJson(defaultMedia: true)], videoEnabled: true);

      expect(toggleButton(), findsNothing);
      await finish(tester);
    });

    testWidgets('is hidden while another device is playing', (tester) async {
      await pumpBigPlayer(tester, files: [audioFileJson(), videoFileJson()], playingLocally: false);

      expect(toggleButton(), findsNothing);
      await finish(tester);
    });
  });

  group('artwork', () {
    testWidgets('shows the podcast image while listening', (tester) async {
      await pumpBigPlayer(tester, files: [audioFileJson(), videoFileJson()]);

      expect(find.byType(PodcastImage), findsOneWidget);
      expect(find.byType(PlayerVideo), findsNothing);
      await finish(tester);
    });

    testWidgets('the video replaces the podcast image while watching', (tester) async {
      await pumpBigPlayer(tester, files: [audioFileJson(), videoFileJson()], videoEnabled: true, showingVideo: true);

      expect(find.byType(PlayerVideo), findsOneWidget);
      expect(find.byType(PodcastImage), findsNothing);
      await finish(tester);
    });

    testWidgets('shows the podcast image when the video is enabled but not playing yet', (tester) async {
      // e.g. while the big player animates in, before the playback is handed over to the video player
      await pumpBigPlayer(tester, files: [videoFileJson(defaultMedia: true)], videoEnabled: true);

      expect(find.byType(PodcastImage), findsOneWidget);
      expect(find.byType(PlayerVideo), findsNothing);
      await finish(tester);
    });
  });

  testWidgets('PlayerVideo renders nothing until a video has been loaded', (tester) async {
    await tester.pumpWidget(wrapWithMaterial(child: const Center(child: PlayerVideo())));

    expect(find.byType(Video), findsNothing);
    expect(tester.getSize(find.byType(PlayerVideo)), Size.zero);
  });
}
