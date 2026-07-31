import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for ProxyApi
void main() {
  final instance = Openapi().getProxyApi();

  group(ProxyApi, () {
    //Future<Object> proxyImage(String url, { String ifNoneMatch }) async
    test('test proxyImage', () async {
      // TODO
    });

  });
}
