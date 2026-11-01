import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nock/nock.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku_shared/podku_shared.dart';

import '../test_helper.dart';

const _videoUrl = '$testServerUrl/media/audio/encrypted-http://example.com/episode.mp4';

void main() {
  late FakeAudioHandler handler;
  late PlayerCubit cubit;

  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
    handler = FakeAudioHandler();
    if (getIt.isRegistered<PodkuAudioHandler>()) {
      getIt.unregister<PodkuAudioHandler>();
    }
    getIt.registerSingleton<PodkuAudioHandler>(handler);
    cubit = PlayerCubit(const PlayerState());
  });

  tearDown(() async {
    // the cubit saves the playback progress with throttled and debounced timers
    EasyThrottle.cancelAll();
    EasyDebounce.cancelAll();
    await cubit.close();
  });

  Future<Episode> play(List<Map<String, dynamic>> files) async {
    final json = createMockEpisodeJson(files: files);
    nock(
      testServerUrl,
    ).get('/api/episodes/${json['id']}').reply(200, jsonEncode(json), headers: {'content-type': 'application/json'});
    nock(testServerUrl).post('/api/episodes/startPlayback', (dynamic _) => true).reply(200, '');

    final episode = Episode.fromJson(json);
    await cubit.playEpisode(episode);
    expect(cubit.state.error, isNull);
    return episode;
  }

  group('starting an episode', () {
    test('watches an episode whose default media is a video', () async {
      await play([audioFileJson(defaultMedia: false), videoFileJson(defaultMedia: true)]);

      expect(cubit.state.videoEnabled, isTrue);
      expect(cubit.state.showingVideo, isTrue);
      expect(handler.switches, ['video:$_videoUrl']);
    });

    test('watches an episode that only has a video', () async {
      await play([videoFileJson(defaultMedia: true)]);

      expect(cubit.state.showingVideo, isTrue);
      expect(handler.switches, ['video:$_videoUrl']);
    });

    test('listens to an episode whose default media is an audio', () async {
      await play([audioFileJson(), videoFileJson()]);

      expect(cubit.state.videoEnabled, isFalse);
      expect(cubit.state.showingVideo, isFalse);
      expect(handler.switches, isEmpty);
    });

    test('listens to an audio only episode', () async {
      await play([audioFileJson()]);

      expect(cubit.state.showingVideo, isFalse);
      expect(handler.switches, isEmpty);
    });

    test('a new episode starts with its own default media', () async {
      await play([audioFileJson(defaultMedia: false), videoFileJson(defaultMedia: true)]);
      expect(cubit.state.showingVideo, isTrue);

      final json = createMockEpisodeJson(
        id: '223e4567-e89b-12d3-a456-426614174999',
        files: [audioFileJson(), videoFileJson()],
      );
      nock(
        testServerUrl,
      ).get('/api/episodes/${json['id']}').reply(200, jsonEncode(json), headers: {'content-type': 'application/json'});
      nock(testServerUrl).post('/api/episodes/startPlayback', (dynamic _) => true).reply(200, '');
      await cubit.playEpisode(Episode.fromJson(json));

      expect(cubit.state.videoEnabled, isFalse);
      expect(cubit.state.showingVideo, isFalse);
    });
  });

  group('switching between audio and video', () {
    test('toggles the video of an episode with both an audio and a video', () async {
      await play([audioFileJson(), videoFileJson()]);

      cubit.toggleVideo();
      await pumpEventQueue();
      expect(cubit.state.videoEnabled, isTrue);
      expect(cubit.state.showingVideo, isTrue);

      cubit.toggleVideo();
      await pumpEventQueue();
      expect(cubit.state.videoEnabled, isFalse);
      expect(cubit.state.showingVideo, isFalse);

      expect(handler.switches, ['video:$_videoUrl', 'audio']);
    });

    test('never shows a video for an audio only episode', () async {
      await play([audioFileJson()]);

      cubit.toggleVideo();
      await pumpEventQueue();

      expect(cubit.state.showingVideo, isFalse);
      expect(handler.switches, isEmpty);
    });
  });

  group('big player visibility', () {
    test('listens while the big player is minimized and watches again when it is shown', () async {
      await play([audioFileJson(defaultMedia: false), videoFileJson(defaultMedia: true)]);

      cubit.showPlayers(true, false);
      await pumpEventQueue();
      expect(cubit.state.showingVideo, isFalse);
      expect(cubit.state.videoEnabled, isTrue, reason: 'the video is resumed when the big player is shown again');

      cubit.showPlayers(false, true);
      await pumpEventQueue();
      expect(cubit.state.showingVideo, isTrue);

      expect(handler.switches, ['video:$_videoUrl', 'audio', 'video:$_videoUrl']);
    });

    test('listens while the players are hidden', () async {
      await play([videoFileJson(defaultMedia: true)]);

      cubit.setHidePlayers(true);
      await pumpEventQueue();
      expect(cubit.state.showingVideo, isFalse);

      cubit.setHidePlayers(false);
      await pumpEventQueue();
      expect(cubit.state.showingVideo, isTrue);
    });

    test('listens while the app is in the background', () async {
      await play([videoFileJson(defaultMedia: true)]);

      cubit.didChangeAppLifecycleState(AppLifecycleState.paused);
      await pumpEventQueue();
      expect(cubit.state.showingVideo, isFalse);

      cubit.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await pumpEventQueue();
      expect(cubit.state.showingVideo, isTrue);

      expect(handler.switches, ['video:$_videoUrl', 'audio', 'video:$_videoUrl']);
    });

    test('keeps the video while the app is only inactive', () async {
      await play([videoFileJson(defaultMedia: true)]);

      cubit.didChangeAppLifecycleState(AppLifecycleState.inactive);
      await pumpEventQueue();

      expect(cubit.state.showingVideo, isTrue);
      expect(handler.switches, ['video:$_videoUrl']);
    });
  });

  group('stopping and remote playback', () {
    test('stopping the playback hides the video', () async {
      await play([videoFileJson(defaultMedia: true)]);

      cubit.stop();

      expect(cubit.state.showingVideo, isFalse);
      expect(cubit.state.videoEnabled, isFalse);
      expect(handler.videoActive, isFalse);
    });

    test('does not show a video while another device is playing', () async {
      await play([audioFileJson(), videoFileJson()]);
      cubit.setCurrentPlayer(PlayerInfo(id: 'another-device', name: 'Another device'));

      cubit.toggleVideo();
      await pumpEventQueue();

      expect(cubit.state.showingVideo, isFalse);
      expect(handler.switches, isEmpty);
    });

    test('does not show a video while offline', () async {
      final serverState = getIt.get<ServerCubit>().state;
      getIt.unregister<ServerCubit>();
      getIt.registerSingleton<ServerCubit>(
        TestServerCubit(serverState.copyWith(status: InternetConnectionStatus.disconnected)),
      );

      await play([videoFileJson(defaultMedia: true)]);

      expect(cubit.state.videoEnabled, isTrue);
      expect(cubit.state.showingVideo, isFalse);
      expect(handler.switches, isEmpty);
    });
  });
}
