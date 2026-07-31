import 'dart:convert';

import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

extension PodcastExtension on Podcast {
  String get artUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/api/images/proxy?url=${Uri.encodeComponent(artworkUrl ?? '')}';

  Uri get artUri => Uri.parse(artUrl);

  PodcastLight get light => PodcastLight.fromJson(toJson());
}

extension PodcastLightExtension on PodcastLight {
  String get artUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/api/images/proxy?url=${Uri.encodeComponent(artworkUrl ?? '')}';

  Uri get artUri => Uri.parse(artUrl);
}
