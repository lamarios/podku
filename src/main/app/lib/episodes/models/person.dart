import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

extension PersonArt on EpisodePerson {
  String get imageUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/media/image/${sha256.convert(utf8.encode(image ?? ''))}';
}
