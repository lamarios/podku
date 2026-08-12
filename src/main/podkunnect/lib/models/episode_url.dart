import 'dart:convert';

import 'package:openapi/openapi.dart';
import 'package:crypto/crypto.dart';

extension EpisodeUrl on Episode {
  String audioProxyUrl(String serverUrl) => '$serverUrl/media/audio/${sha256.convert(utf8.encode(audioUrl ?? ''))}';
}
