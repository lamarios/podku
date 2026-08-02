import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SearchApi
void main() {
  final instance = Openapi().getSearchApi();

  group(SearchApi, () {
    //Future<List<SearchResult>> search(String query, int limit) async
    test('test search', () async {
      // TODO
    });

  });
}
