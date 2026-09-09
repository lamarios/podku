import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:test/test.dart';

import 'mocks/mock_player.dart';

void main() {
  bool hasNativeMpv = false;
  try {
    MediaKit.ensureInitialized();
    hasNativeMpv = true;
  } catch (_) {
    // libmpv is not available in this environment (e.g. CI runner without libmpv-dev)
  }

  test('player open and dispose with mock player', () async {
    final player = createMockPlayer();
    await player.open(Media('http://localhost:8080/test_silent.mp3'), play: false);
    expect(player.state.playing, isFalse);
    await player.stop();
    await player.dispose();
  });

  test('player open and dispose with native file', () async {
    final tempFile = File('${Directory.systemTemp.path}/test_silent.mp3');
    await tempFile.writeAsBytes([0xFF, 0xFB, 0x90, 0x64, 0x00]); // MP3 header
    final player = Player();
    await player.open(Media(tempFile.uri.toString()), play: false);
    await Future.delayed(const Duration(milliseconds: 100));
    await player.stop();
    await player.dispose();
    await tempFile.delete();
  }, skip: hasNativeMpv ? false : 'libmpv not installed in current environment');
}
