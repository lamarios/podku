import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

extension PersonArt on EpisodePerson {
  String get imageUrl =>
      '${getIt.get<ServerCubit>().state.serverUrl}/api/images/proxy?url=${Uri.encodeComponent(image ?? '')}';
}
