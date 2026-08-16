import 'package:openapi/openapi.dart';

extension EpisodeUrl on Episode {
  String audioProxyUrl(String serverUrl) => '$serverUrl/media/audio/$audioUrlEncrypted';
}
