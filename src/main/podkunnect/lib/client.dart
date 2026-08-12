import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

class Client {
  late final EpisodesApi episodes;
  late final Openapi _client;
  final String serverUrl;

  Client(this.serverUrl) {
    BaseOptions options = BaseOptions(
      baseUrl: serverUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    );

    final dio = Dio(options);

    _client = Openapi(basePathOverride: serverUrl, dio: dio);
    episodes = _client.getEpisodesApi();
  }
}
