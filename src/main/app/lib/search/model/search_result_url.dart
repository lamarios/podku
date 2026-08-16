import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

extension SearchResultUrl on SearchResult {
  String get artUrl => '${getIt.get<ServerCubit>().state.serverUrl}/media/image/$artworkUrlEncrypted';
}
