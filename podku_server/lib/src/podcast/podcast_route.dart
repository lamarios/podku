import 'dart:async';

import 'package:podku_server/src/generated/podcast/podcast.dart';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;

class PodcastRoute extends Route {
  PodcastRoute() : super(methods: {Method.get});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.get) {
        final artUrl = request.queryParameters.raw['art'];

      if (artUrl== null) {
        return Response.notFound();
      }

      final response = await http.get(Uri.parse(artUrl));

      var bodyBytes = response.bodyBytes;

      return Response.ok(
        body: Body.fromData(bodyBytes),
        headers: Headers.build((h) {
          h.accessControlAllowOrigin = AccessControlAllowOriginHeader.wildcard();
          // copy over whatever downstream headers you're already forwarding here too
        }),
      );
    }

    throw UnimplementedError();
  }
}
