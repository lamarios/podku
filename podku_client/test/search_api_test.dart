import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for SearchApi
void main() {
  final instance = Openapi().getSearchApi();

  group(SearchApi, () {
    //Future<List<SearchResult>> search(String body) async
    test('test search', () async {
      // TODO
    });

  });
}
