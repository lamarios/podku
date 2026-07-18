import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

@Deprecated('Using the reverse_proxy.dart file now so that websocket can also be proxied')
class ApiRedirectRoute extends Route {
  ApiRedirectRoute()
    : super(
        methods: {
          Method.get,
          Method.post,
          Method.put,
          Method.patch,
          Method.delete,
          Method.head,
          Method.options,
        },
      );

  // Headers that must not be blindly forwarded between hops.
  static final _client = http.Client();

  @override
  Future<Result> handleCall(Session session, Request request) async {
    // request.remainingPath is the part of the path after the matched
    // route prefix (e.g. registering this route at '/api/**' means a
    // request to /api/users/5 gives remainingPath = 'users/5').
    final forwardedPath = request.remainingPath.toString();

    final target = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8080,
      // the API/service server
      path: '$forwardedPath',
      query: request.url.query.isEmpty ? null : request.url.query,
    );

    // Buffer the incoming body fully before forwarding — simpler and
    // safer than trying to pipe two streams concurrently.
    final bodyBytes = await request.read().expand((chunk) => chunk).toList();

    final proxied = http.Request(request.method.name.toUpperCase(), target)..bodyBytes = bodyBytes;

    // TODO verify: confirm how to iterate this request's headers on
    // your Relic version — assumes a Map-like forEach(name, values).
    request.headers.forEach((name, values) {
      // if (_hopByHopHeaders.contains(name.toLowerCase())) return;
      proxied.headers[name] = values.join(', ');
    });

    final streamed = await _client.send(proxied);
    final responseBytes = await streamed.stream.toBytes();

    // TODO verify: confirm how to attach passthrough headers to the
    // Response constructor on your version.
    return Response(
      streamed.statusCode,
      headers: Headers.fromMap(
        streamed.headers.map(
          (key, value) => MapEntry(key, [value]),
        ),
      ),
      body: Body.fromData(
        responseBytes,
        mimeType: MimeType.parse(streamed.headers['content-type'] ?? 'application/json'),
      ),
    );
  }
}
