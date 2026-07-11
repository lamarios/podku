import 'package:podku_client/podku_client.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

extension PodcastExtension on Podcast {
  String get artUrl => '${getIt.get<ServerCubit>().state.serverUrl}/podcasts/image?art=${Uri.encodeComponent(artworkUrl ?? '')}';

  Uri get artUri => Uri.parse('${getIt.get<ServerCubit>().state.serverUrl}/podcasts/image?art=${Uri.encodeComponent(artworkUrl ?? '')}');
}
