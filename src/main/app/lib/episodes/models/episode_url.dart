import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku_shared/podku_shared.dart';

extension EpisodeUrl on Episode {
  /// The file played when listening to the episode: its audio, or its video played as audio when it only has a video.
  EpisodeFile? get listeningFile => audioFile ?? videoFile;

  String get audioProxyUrl => _proxyUrl(listeningFile);

  String? get videoProxyUrl => videoFile == null ? null : _proxyUrl(videoFile);

  /// Whether the episode should be watched rather than listened to by default.
  bool get defaultsToVideo => defaultMedia?.type == EpisodeFileTypeEnum.video;

  /// Whether the episode can be both watched and listened to.
  bool get canSwitchVideo => audioFile != null && videoFile != null;

  // the backend proxies the media, avoiding CORS issues
  String _proxyUrl(EpisodeFile? file) =>
      '${getIt.get<ServerCubit>().state.serverUrl}/media/audio/${file?.urlEncrypted}';
}
