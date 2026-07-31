import 'package:openapi/openapi.dart';

class Client {
  late final PodcastsApi podcasts;
  late final EpisodesApi episodes;
  late final TranscriptsApi transcripts;
  late final ProxyApi proxy;
  late final SearchApi search;
  late final Openapi _client;

  Client(String serverUrl) {
    _client = Openapi(basePathOverride: serverUrl);
    podcasts = _client.getPodcastsApi();
    episodes = _client.getEpisodesApi();
    transcripts = _client.getTranscriptsApi();
    proxy = _client.getProxyApi();
    search = _client.getSearchApi();
  }
}
