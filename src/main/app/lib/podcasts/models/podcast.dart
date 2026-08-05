import 'dart:convert';

import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:crypto/crypto.dart';

extension PodcastExtension on Podcast {
  String get artUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/media/image/${sha256.convert(utf8.encode(artworkUrl ?? ''))}';

  Uri get artUri => Uri.parse(artUrl);

  PodcastLight get light => PodcastLight.fromJson(toJson());
}

extension PodcastLightExtension on PodcastLight {
  String get artUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/media/image/${sha256.convert(utf8.encode(artworkUrl ?? ''))}';

  Uri get artUri => Uri.parse(artUrl);
}
