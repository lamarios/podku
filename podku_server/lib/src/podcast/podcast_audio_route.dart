import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:serverpod/serverpod.dart';

class PodcastAudioRoute extends Route {
  PodcastAudioRoute() : super(methods: {Method.get});

  @override
  FutureOr<Result> handleCall(Session session, Request request) async {
    if (request.method == Method.get) {
      final audioUrl = request.queryParameters.raw['url'];

      if (audioUrl == null) {
        return Response.notFound();
      }

      final Map<String, String> headers = {};
      // Only forward headers that are safe/necessary for the origin request.
      const forwardable = {'range', 'accept', 'user-agent'};
      request.headers.forEach((name, values) {
        if (forwardable.contains(name.toLowerCase())) {
          headers[name] = values.join(', ');
        }
      });

      var getRequest = http.Request('GET', Uri.parse(audioUrl))
        ..followRedirects = true
        ..maxRedirects = 50
        ..headers.addAll(headers);

      final response = await http.Client().send(getRequest);

      final byteStream = response.stream.map(
        (chunk) => chunk is Uint8List ? chunk : Uint8List.fromList(chunk),
      );

      final responseHeaders = Map<String, Iterable<String>>.from(Headers.build((h) {
        h.accessControlAllowOrigin = AccessControlAllowOriginHeader.wildcard();
        // copy over whatever downstream headers you're already forwarding here too
      }));


      responseHeaders.addAll(
        response.headers.map(
          (key, value) => MapEntry(key, [value]),
        ),
      );

      return Response(
        response.statusCode,
        body: Body.fromDataStream(
          byteStream,
          contentLength: response.contentLength,
        ),

        headers: Headers.fromMap(responseHeaders),
      );
    } else {
      return Response.forbidden();
    }
  }
}
