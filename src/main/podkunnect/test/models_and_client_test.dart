import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';
import 'package:podkunnect/client.dart';
import 'package:podkunnect/models/episode_url.dart';
import 'package:test/test.dart';

void main() {
  group('EpisodeUrl extension tests', () {
    test('audioProxyUrl builds correct audio proxy URL from encrypted hash', () {
      final episode = Episode(
        id: 'ep-123',
        title: 'Test Episode',
        files: [EpisodeFile(type: EpisodeFileTypeEnum.audio, urlEncrypted: 'a1b2c3d4e5f6')],
      );

      final url = episode.audioProxyUrl('http://localhost:8080');
      expect(url, equals('http://localhost:8080/media/audio/a1b2c3d4e5f6'));
    });

    test('audioProxyUrl preserves server base without trailing slash', () {
      final episode = Episode(
        id: 'ep-456',
        title: 'Another Episode',
        files: [EpisodeFile(type: EpisodeFileTypeEnum.audio, urlEncrypted: 'xyz789')],
      );

      final url = episode.audioProxyUrl('https://podku.example.com:9000');
      expect(url, equals('https://podku.example.com:9000/media/audio/xyz789'));
    });

    test('audioProxyUrl uses the default audio file, ignoring video', () {
      final episode = Episode(
        id: 'ep-789',
        title: 'Media Episode',
        files: [
          EpisodeFile(type: EpisodeFileTypeEnum.transcript, urlEncrypted: 'transcript'),
          EpisodeFile(type: EpisodeFileTypeEnum.video, urlEncrypted: 'video', defaultMedia: true),
          EpisodeFile(type: EpisodeFileTypeEnum.audio, urlEncrypted: 'alternate', defaultMedia: false),
          EpisodeFile(type: EpisodeFileTypeEnum.audio, urlEncrypted: 'default', defaultMedia: true),
        ],
      );

      expect(episode.audioProxyUrl('http://localhost:8080'), equals('http://localhost:8080/media/audio/default'));
    });

    test('audioProxyUrl falls back to the first audio file without a default one', () {
      final episode = Episode(
        id: 'ep-790',
        title: 'No Default',
        files: [
          EpisodeFile(type: EpisodeFileTypeEnum.video, urlEncrypted: 'video'),
          EpisodeFile(type: EpisodeFileTypeEnum.audio, urlEncrypted: 'first'),
          EpisodeFile(type: EpisodeFileTypeEnum.audio, urlEncrypted: 'second'),
        ],
      );

      expect(episode.audioProxyUrl('http://localhost:8080'), equals('http://localhost:8080/media/audio/first'));
    });
  });

  group('Client initialization tests', () {
    test('initializes default openapi and episodes api with serverUrl', () {
      final client = Client('http://localhost:8080');

      expect(client.serverUrl, equals('http://localhost:8080'));
      expect(client.episodes, isNotNull);
    });

    test('accepts custom Dio instance', () {
      final customDio = Dio(BaseOptions(baseUrl: 'http://custom-server:8080'));
      final client = Client('http://custom-server:8080', dio: customDio);

      expect(client.serverUrl, equals('http://custom-server:8080'));
      expect(client.episodes, isNotNull);
    });

    test('accepts injected EpisodesApi directly', () {
      final dio = Dio();
      final openapi = Openapi(dio: dio);
      final customEpisodes = openapi.getEpisodesApi();

      final client = Client('http://mock-server:8080', episodes: customEpisodes, openapi: openapi);

      expect(client.episodes, same(customEpisodes));
      expect(client.serverUrl, equals('http://mock-server:8080'));
    });
  });
}
