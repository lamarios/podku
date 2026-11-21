import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for RecommendationsApi
void main() {
  final instance = Openapi().getRecommendationsApi();

  group(RecommendationsApi, () {
    //Future<List<SearchResult>> getEpisodeRecommendations(String episodeId, { int limit }) async
    test('test getEpisodeRecommendations', () async {
      // TODO
    });

  });
}
