import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/player_video_controls.dart';
import 'package:podku/utils.dart';

import '../test_helper.dart';

/// Player cubit recording the playback commands of the video controls.
class ControlsPlayerCubit extends FakePlayerCubit {
  final List<String> commands = [];

  ControlsPlayerCubit(super.state);

  @override
  void playPause() {
    commands.add('playPause');
    emit(state.copyWith(playing: !state.playing));
  }

  @override
  void skip(int seconds) => commands.add('skip:$seconds');

  @override
  void setFullscreen(bool fullscreen) {
    if (!isClosed) emit(state.copyWith(fullscreen: fullscreen));
  }
}

void main() {
  setUp(() {
    setupTestGetIt();
  });

  Future<ControlsPlayerCubit> pumpControls(WidgetTester tester, Widget controls, {bool playing = true}) async {
    final cubit = ControlsPlayerCubit(PlayerState(playing: playing, showingVideo: true));
    addTearDown(cubit.close);
    await tester.pumpWidget(wrapWithMaterial(playerCubit: cubit, child: controls));
    await tester.pump();
    return cubit;
  }

  // the middle of the controls is the play / pause button
  Future<void> tapBackground(WidgetTester tester) async {
    await tester.tapAt(tester.getBottomLeft(find.byType(FullscreenVideoControls)) + const Offset(20, -20));
    await tester.pump();
  }

  bool controlsVisible(WidgetTester tester) =>
      tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity == 1;

  testWidgets('the video in the big player has a full screen button', (tester) async {
    await pumpControls(tester, const PlayerVideoControls());

    expect(find.byTooltip('Full screen'), findsOneWidget);
    expect(find.byType(FullscreenVideoControls), findsNothing);
  });

  group('full screen controls', () {
    testWidgets('rewinds, plays / pauses and skips forward', (tester) async {
      final cubit = await pumpControls(tester, const FullscreenVideoControls());

      await tester.tap(find.byTooltip('Rewind 10 seconds'));
      await tester.tap(find.byTooltip('Pause'));
      await tester.pump();
      await tester.tap(find.byTooltip('Play'));
      await tester.tap(find.byTooltip('Skip forward 10 seconds'));

      expect(cubit.commands, ['skip:-10', 'playPause', 'playPause', 'skip:10']);
      expect(find.byTooltip('Exit full screen'), findsOneWidget);
    });

    testWidgets('has keyboard shortcuts', (tester) async {
      final cubit = await pumpControls(tester, const FullscreenVideoControls());

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);

      expect(cubit.commands, ['skip:-10', 'playPause', 'skip:10']);
    });

    testWidgets('hide after a few seconds while playing and come back on tap', (tester) async {
      await pumpControls(tester, const FullscreenVideoControls());
      expect(controlsVisible(tester), isTrue);

      await tester.pump(FullscreenVideoControls.hideDelay);
      expect(controlsVisible(tester), isFalse);

      await tapBackground(tester);
      expect(controlsVisible(tester), isTrue);

      await tapBackground(tester);
      expect(controlsVisible(tester), isFalse, reason: 'tapping again hides them');
    });

    testWidgets('stay visible while paused', (tester) async {
      await pumpControls(tester, const FullscreenVideoControls(), playing: false);

      await tester.pump(FullscreenVideoControls.hideDelay * 2);

      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('come back when the playback is paused', (tester) async {
      final cubit = await pumpControls(tester, const FullscreenVideoControls());
      await tester.pump(FullscreenVideoControls.hideDelay);
      expect(controlsVisible(tester), isFalse);

      cubit.emit(cubit.state.copyWith(playing: false));
      await tester.pump();

      expect(controlsVisible(tester), isTrue);
    });

    testWidgets('flag the player as full screen while shown', (tester) async {
      final cubit = await pumpControls(tester, const FullscreenVideoControls());
      expect(cubit.state.fullscreen, isTrue);

      await tester.pumpWidget(wrapWithMaterial(playerCubit: cubit, child: const SizedBox()));
      await tester.pump();

      expect(cubit.state.fullscreen, isFalse);
    });
  });

  group('back button', () {
    late PlayerCubit cubit;

    setUp(() {
      if (getIt.isRegistered<PodkuAudioHandler>()) {
        getIt.unregister<PodkuAudioHandler>();
      }
      getIt.registerSingleton<PodkuAudioHandler>(FakeAudioHandler());
      cubit = PlayerCubit(const PlayerState());
    });

    tearDown(() async {
      EasyThrottle.cancelAll();
      EasyDebounce.cancelAll();
      await cubit.close();
    });

    test('leaves the full screen video instead of minimizing the big player', () {
      cubit.showPlayers(false, true);
      cubit.setFullscreen(true);

      final handled = cubit.backButtonInterceptor(false, RouteInfo());

      expect(handled, isFalse, reason: 'the full screen route handles the back button');
      expect(cubit.state.showBigPlayer, isTrue);
    });

    test('closes a popup opened over the big player instead of minimizing it', () async {
      cubit.showPlayers(false, true);
      final popup = Completer<void>();

      final shown = cubit.showOverPlayer(() => popup.future);
      expect(cubit.backButtonInterceptor(false, RouteInfo()), isFalse, reason: 'the popup route handles it');
      expect(cubit.state.showBigPlayer, isTrue);

      popup.complete();
      await shown;
      expect(cubit.backButtonInterceptor(false, RouteInfo()), isTrue, reason: 'the popup is closed');
    });

    test('keeps tracking popups that fail', () async {
      cubit.showPlayers(false, true);

      await expectLater(cubit.showOverPlayer<void>(() => Future.error('failed')), throwsA('failed'));

      expect(cubit.backButtonInterceptor(false, RouteInfo()), isTrue);
    });

    test('is handled by the player when not full screen', () {
      cubit.showPlayers(false, true);

      expect(cubit.backButtonInterceptor(false, RouteInfo()), isTrue);
    });
  });
}
