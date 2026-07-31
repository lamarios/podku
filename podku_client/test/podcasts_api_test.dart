import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for PodcastsApi
void main() {
  final instance = Openapi().getPodcastsApi();

  group(PodcastsApi, () {
    //Future<Podcast> getPodcast(String id) async
    test('test getPodcast', () async {
      // TODO
    });

    //Future<List<PodcastLight>> getPodcasts() async
    test('test getPodcasts', () async {
      // TODO
    });

    //Future<Podcast> parsePodcast(SearchResult searchResult) async
    test('test parsePodcast', () async {
      // TODO
    });

    //Future<Podcast> subscribeToPodcast(SearchResult searchResult) async
    test('test subscribeToPodcast', () async {
      // TODO
    });

    //Future unsubsribe(String id) async
    test('test unsubsribe', () async {
      // TODO
    });

  });
}
