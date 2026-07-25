import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

extension PersonArt on EpisodePerson {
  String get imageUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/file-proxy?url=${Uri.encodeComponent(image ?? '')}';
}
