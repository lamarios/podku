import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for TranscriptsApi
void main() {
  final instance = Openapi().getTranscriptsApi();

  group(TranscriptsApi, () {
    //Future<List<String>> getEpisodeLanguages(String id) async
    test('test getEpisodeLanguages', () async {
      // TODO
    });

    //Future<List<EpisodeTranscript>> getTranscript(String id, String language) async
    test('test getTranscript', () async {
      // TODO
    });

    //Future<List<String>> summarizePast5minutes(String id, String language, int until) async
    test('test summarizePast5minutes', () async {
      // TODO
    });

  });
}
