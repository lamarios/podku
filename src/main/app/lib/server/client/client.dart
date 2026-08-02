import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

class Client {
  late final PodcastsApi podcasts;
  late final EpisodesApi episodes;
  late final TranscriptsApi transcripts;
  late final ProxyApi proxy;
  late final SearchApi search;
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
    podcasts = _client.getPodcastsApi();
    episodes = _client.getEpisodesApi();
    transcripts = _client.getTranscriptsApi();
    proxy = _client.getProxyApi();
    search = _client.getSearchApi();
  }
}
