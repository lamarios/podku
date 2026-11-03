import 'package:openapi/openapi.dart';
import 'package:podku_shared/podku_shared.dart';

extension EpisodeUrl on Episode {
  String audioProxyUrl(String serverUrl) => '$serverUrl/media/audio/${audioFile?.urlEncrypted}';
}
