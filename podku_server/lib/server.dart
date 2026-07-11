import 'dart:io';

import 'package:podku_server/src/api/redirect_router.dart';
import 'package:podku_server/src/podcast/podcast_audio_route.dart';
import 'package:podku_server/src/podcast/podcast_route.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/routes/app_config_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // CORS.
  final headers = Headers.build((h) {
    h.accessControlAllowOrigin = AccessControlAllowOriginHeader.wildcard();
    h.accessControlAllowMethods = AccessControlAllowMethodsHeader.methods([
      Method.get,
      Method.post,
      Method.put,
      Method.delete,
      Method.options,
      Method.head,
    ]);
    h.accessControlAllowHeaders = AccessControlAllowHeadersHeader.wildcard();
  });
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints(), httpResponseHeaders: headers, httpOptionsResponseHeaders: headers);


  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );

  // Setup a default page at the web root.
  // These are used by the default page.
  // pod.webServer.addRoute(RootRoute(), '/');
  // pod.webServer.addRoute(RootRoute(), '/index.html');
  pod.webServer.addRoute(PodcastRoute(), '/podcasts/image');
  pod.webServer.addRoute(PodcastAudioRoute(), '/podcasts/audio');
  pod.webServer.addRoute(ApiRedirectRoute(), '/api/**');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
/*
  final root = Directory(Uri(path: 'web/').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));
*/

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web').toFilePath(),
        ),
      ),
      '/',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Start the server.
  await pod.start();


  // refresh podcasts job
  await pod.futureCalls.callWithDelay(Duration(seconds: 10)).podcastRefresh.refreshPodcasts();
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
