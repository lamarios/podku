import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

extension EpisodeUrl on Episode {
  String get audioProxyUrl => '${getIt.get<ServerCubit>().state.serverUrl}/media/audio/$audioUrlEncrypted';
}
