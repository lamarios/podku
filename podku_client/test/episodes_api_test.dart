import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for EpisodesApi
void main() {
  final instance = Openapi().getEpisodesApi();

  group(EpisodesApi, () {
    //Future<Episode> getEpisode(String id) async
    test('test getEpisode', () async {
      // TODO
    });

    //Future<List<Episode>> getEpisodes({ int before, int pageSize }) async
    test('test getEpisodes', () async {
      // TODO
    });

    //Future<Object> proxyAudio(String url, { String range }) async
    test('test proxyAudio', () async {
      // TODO
    });

    //Future<List<Episode>> search2(String query, int limit) async
    test('test search2', () async {
      // TODO
    });

    //Future setProgress(PlaybackProgress playbackProgress) async
    test('test setProgress', () async {
      // TODO
    });

    //Future startPlayback(PlaybackProgress playbackProgress) async
    test('test startPlayback', () async {
      // TODO
    });

  });
}
