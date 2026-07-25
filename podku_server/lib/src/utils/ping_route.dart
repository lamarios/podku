import 'dart:async';

import 'package:serverpod/serverpod.dart';

class PingRoute extends Route {
  PingRoute() : super(methods: {.get, .options, .post, .head,});
  @override
  Future<Result> handleCall(Session session, Request request) async {
    return Response.ok(
      headers: Headers.build((h) {
        h.accessControlAllowOrigin = AccessControlAllowOriginHeader.wildcard();
        h.accessControlAllowMethods= AccessControlAllowMethodsHeader.methods(Method.values);
        h.accessControlAllowHeaders = AccessControlAllowHeadersHeader.wildcard();
      }),
    );
  }
}
