import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for MediaApi
void main() {
  final instance = Openapi().getMediaApi();

  group(MediaApi, () {
    //Future<Object> getImage(String hash, { String ifNoneMatch }) async
    test('test getImage', () async {
      // TODO
    });

    //Future<Object> proxyAudio(String hash, { String range }) async
    test('test proxyAudio', () async {
      // TODO
    });

  });
}
