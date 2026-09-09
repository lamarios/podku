import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    MediaKit.ensureInitialized();
  });

  test('player open and dispose with file', () async {
    final tempFile = File('${Directory.systemTemp.path}/test_silent.mp3');
    await tempFile.writeAsBytes([0xFF, 0xFB, 0x90, 0x64, 0x00]); // MP3 header
    final player = Player();
    await player.open(Media(tempFile.uri.toString()), play: false);
    await Future.delayed(const Duration(milliseconds: 100));
    await player.stop();
    await player.dispose();
    await tempFile.delete();
  });
}
