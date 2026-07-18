import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

extension EpisodeUrl on Episode {
  String get audioProxyUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/podcasts/audio?url=${Uri.encodeComponent(audioUrl ?? '')}';
}
