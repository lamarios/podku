import 'dart:async';
import 'dart:io';

import 'package:podku_server/src/utils/caching.dart';
import 'package:serverpod/serverpod.dart';

class PodcastRoute extends Route {
  late final UrlFileCache cache;

  PodcastRoute() : super(methods: {Method.get}) {
    final cacheDir = Directory('./cache');
    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }
    cache = UrlFileCache(cacheDir);
  }

  @override
  Future<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.get) {
      final artUrl = request.queryParameters.raw['art'];

      if (artUrl == null) {
        return Response.notFound();
      }

      final file = await cache.getFile(artUrl, maxAge: Duration(days: 30));

      var bodyBytes = await file.readAsBytes();

      return Response.ok(
        body: Body.fromData(bodyBytes),
        headers: Headers.build((h) {
          h.accessControlAllowOrigin = AccessControlAllowOriginHeader.wildcard();
        }),
      );
    }

    throw UnimplementedError();
  }
}
