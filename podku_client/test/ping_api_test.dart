import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for PingApi
void main() {
  final instance = Openapi().getPingApi();

  group(PingApi, () {
    //Future<String> ping() async
    test('test ping', () async {
      // TODO
    });

  });
}
