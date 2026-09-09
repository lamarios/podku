import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

class Client {
  late final EpisodesApi episodes;
  late final Openapi _client;
  final String serverUrl;

  Client(this.serverUrl, {EpisodesApi? episodes, Openapi? openapi, Dio? dio}) {
    if (episodes != null) {
      this.episodes = episodes;
      if (openapi != null) {
        _client = openapi;
      }
    } else {
      final options = BaseOptions(
        baseUrl: serverUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      );

      final clientDio = dio ?? Dio(options);

      _client = openapi ?? Openapi(basePathOverride: serverUrl, dio: clientDio);
      this.episodes = _client.getEpisodesApi();
    }
  }
}
