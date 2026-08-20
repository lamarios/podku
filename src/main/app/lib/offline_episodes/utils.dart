import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:openapi/openapi.dart';

import 'package:path_provider/path_provider.dart';
import 'package:podku/main.dart';

class OfflineProgressSaver {
  static final _log = Logger('OfflineProgressSaver');
  static final String _filePath = "offline_progress.json";

  static Future<void> updateProgress({required String episodeId, required int progress}) async {
    if (kIsWeb) return;

    final f = await _getSaveFile();
    final contentStr = await f.readAsString();
    final content = _readContent(contentStr);
    _log.fine('offline content: $content');
    content[episodeId] = OfflineProgress(timeOfProgress: DateTime.now().millisecondsSinceEpoch, progress: progress);

    await f.writeAsString(jsonEncode(content));
  }

  static Map<String, OfflineProgress> _readContent(String str) {
    if (str.trim().isEmpty) {
      return {};
    }
    return (jsonDecode(str) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, OfflineProgress.fromJson(value as Map<String, dynamic>)),
    );
  }

  static Future<void> sendProgressToBackend() async {
    if (kIsWeb) return;
    _log.fine('Sending catch-up progress to backend');
    final f = await _getSaveFile();
    final content = _readContent(await f.readAsString());
    if (content.isNotEmpty) {
      await client.episodes.updateProgresses(requestBody: content);
    }
    // we empty the content on successful backend update
    f.writeAsString("");
  }

  static Future<File> _getSaveFile() async {
    var directory = await getApplicationDocumentsDirectory();
    final File f = File('${directory.path}/$_filePath');
    if (!(await f.exists())) {
      await f.create(recursive: true);
    }
    return f;
  }
}
