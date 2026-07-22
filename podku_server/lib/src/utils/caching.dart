import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class UrlFileCache {
  final Directory cacheDir;
  final _client = http.Client();

  UrlFileCache(this.cacheDir );

  String _keyFor(String url) => sha256.convert(utf8.encode(url)).toString();

  File _fileFor(String url) => File('${cacheDir.path}/${_keyFor(url)}');
  File _metaFor(String url) => File('${cacheDir.path}/${_keyFor(url)}.meta.json');

  /// Returns the local cached file, downloading/refreshing it if needed.
  Future<File> getFile(String url, {Duration? maxAge}) async {
    final file = _fileFor(url);
    final metaFile = _metaFor(url);

    if (await file.exists() && await metaFile.exists()) {
      final meta = jsonDecode(await metaFile.readAsString());
      final fetchedAt = DateTime.parse(meta['fetchedAt']);

      final stillFresh = maxAge != null &&
          DateTime.now().difference(fetchedAt) < maxAge;

      if (stillFresh) return file;

      // Stale by our own TTL — revalidate with the origin using
      // conditional headers instead of blindly re-downloading.
      final etag = meta['etag'] as String?;
      final lastModified = meta['lastModified'] as String?;

      final response = await _client.get(
        Uri.parse(url),
        headers: {
          if (etag != null) 'If-None-Match': etag,
          if (lastModified != null) 'If-Modified-Since': lastModified,
        },
      );

      if (response.statusCode == 304) {
        // Not modified — just refresh our fetchedAt timestamp.
        await _writeMeta(metaFile, response, url);
        return file;
      }

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        await _writeMeta(metaFile, response, url);
        return file;
      }

      // Origin errored — serve stale rather than fail outright.
      return file;
    }

    // Nothing cached yet — full fetch.
    await cacheDir.create(recursive: true);
    final response = await _client.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw HttpException('Failed to fetch $url: ${response.statusCode}');
    }
    await file.writeAsBytes(response.bodyBytes);
    await _writeMeta(metaFile, response, url);
    return file;
  }

  Future<void> _writeMeta(File metaFile, http.Response response, String url) async {
    await metaFile.writeAsString(jsonEncode({
      'url': url,
      'etag': response.headers['etag'],
      'lastModified': response.headers['last-modified'],
      'fetchedAt': DateTime.now().toIso8601String(),
    }));
  }
}