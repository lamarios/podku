import 'package:media_kit/media_kit.dart';

class MockPlatformPlayer extends PlatformPlayer {
  Playable? lastOpenedPlayable;
  Duration lastSeekPosition = Duration.zero;

  MockPlatformPlayer({super.configuration = const PlayerConfiguration()}) {
    state = state.copyWith(volume: 100.0, rate: 1.0, playing: false, position: Duration.zero, duration: Duration.zero);
  }

  @override
  Future<void> open(Playable playable, {bool play = true}) async {
    lastOpenedPlayable = playable;
    state = state.copyWith(playing: play);
    playingController.add(play);
  }

  @override
  Future<void> stop() async {
    state = state.copyWith(playing: false);
    playingController.add(false);
  }

  @override
  Future<void> play() async {
    state = state.copyWith(playing: true);
    playingController.add(true);
  }

  @override
  Future<void> pause() async {
    state = state.copyWith(playing: false);
    playingController.add(false);
  }

  @override
  Future<void> playOrPause() async {
    final next = !state.playing;
    state = state.copyWith(playing: next);
    playingController.add(next);
  }

  @override
  Future<void> seek(Duration duration) async {
    lastSeekPosition = duration;
    state = state.copyWith(position: duration);
    positionController.add(duration);
  }

  @override
  Future<void> setVolume(double volume) async {
    state = state.copyWith(volume: volume);
    volumeController.add(volume);
  }

  @override
  Future<void> setRate(double rate) async {
    state = state.copyWith(rate: rate);
    rateController.add(rate);
  }
}

Player createMockPlayer({MockPlatformPlayer? platformPlayer}) {
  return Player(platformPlayer: platformPlayer ?? MockPlatformPlayer());
}
