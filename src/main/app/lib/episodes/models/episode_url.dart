import 'dart:convert';

import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:crypto/crypto.dart';

extension EpisodeUrl on Episode {
  String get audioProxyUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/media/audio/${sha256.convert(utf8.encode(audioUrl ?? ''))}';
}
