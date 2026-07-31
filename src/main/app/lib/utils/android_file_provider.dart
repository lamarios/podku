import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final _log = Logger('AndroidFileProvider');

class AndroidFileProvider {
  static const _channel = MethodChannel('com.github.lamarios.podku/file_provider');

  static Future<Uri?> getContentUriForFile(String path) async {
    try {
      final uriString = await _channel.invokeMethod<String>('getContentUri', {'path': path});
      return uriString != null ? Uri.parse(uriString) : null;
    } catch (e) {
      _log.warning('Failed to get content:// uri for $path: $e');
      return null;
    }
  }
}
