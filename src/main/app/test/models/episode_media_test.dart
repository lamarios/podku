import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku_shared/podku_shared.dart';

import '../test_helper.dart';

Episode episodeWith(List<Map<String, dynamic>> files) => Episode.fromJson(createMockEpisodeJson(files: files));

void main() {
  setUp(() {
    setupTestGetIt();
  });

  group('EpisodeMedia', () {
    test('picks the default audio and video files', () {
      final episode = episodeWith([
        createMockEpisodeFileJson(type: 'transcript', url: 'http://example.com/a.vtt'),
        audioFileJson(defaultMedia: false, url: 'http://example.com/alternate.mp3'),
        audioFileJson(defaultMedia: true, url: 'http://example.com/default.mp3'),
        videoFileJson(defaultMedia: false, url: 'http://example.com/first.mp4'),
        videoFileJson(defaultMedia: true, url: 'http://example.com/default.mp4'),
      ]);

      expect(episode.audioFile?.url, 'http://example.com/default.mp3');
      expect(episode.videoFile?.url, 'http://example.com/default.mp4');
    });

    test('falls back to the first file of a type without a default one', () {
      final episode = episodeWith([
        videoFileJson(defaultMedia: false, url: 'http://example.com/first.mp4'),
        audioFileJson(defaultMedia: false, url: 'http://example.com/first.mp3'),
        videoFileJson(defaultMedia: false, url: 'http://example.com/second.mp4'),
        audioFileJson(defaultMedia: false, url: 'http://example.com/second.mp3'),
      ]);

      expect(episode.audioFile?.url, 'http://example.com/first.mp3');
      expect(episode.videoFile?.url, 'http://example.com/first.mp4');
      expect(episode.defaultMedia?.url, 'http://example.com/first.mp4');
    });

    test('the default media can be a video', () {
      final episode = episodeWith([audioFileJson(defaultMedia: false), videoFileJson(defaultMedia: true)]);

      expect(episode.defaultMedia?.type, EpisodeFileTypeEnum.video);
    });

    test('has no media without media files', () {
      for (final episode in [
        episodeWith([createMockEpisodeFileJson(type: 'chapters')]),
        Episode.fromJson(createMockEpisodeJson()),
      ]) {
        expect(episode.audioFile, isNull);
        expect(episode.videoFile, isNull);
        expect(episode.defaultMedia, isNull);
      }
    });
  });

  group('EpisodeUrl', () {
    test('listens to the audio and watches the video through the backend proxy', () {
      final episode = episodeWith([audioFileJson(), videoFileJson()]);

      expect(episode.listeningFile?.type, EpisodeFileTypeEnum.audio);
      expect(episode.audioProxyUrl, '$testServerUrl/media/audio/encrypted-http://example.com/episode.mp3');
      expect(episode.videoProxyUrl, '$testServerUrl/media/audio/encrypted-http://example.com/episode.mp4');
      expect(episode.canSwitchVideo, isTrue);
      expect(episode.defaultsToVideo, isFalse);
    });

    test('listens to the video of an episode without audio', () {
      final episode = episodeWith([videoFileJson(defaultMedia: true)]);

      expect(episode.listeningFile?.type, EpisodeFileTypeEnum.video);
      expect(episode.audioProxyUrl, episode.videoProxyUrl);
      expect(episode.canSwitchVideo, isFalse);
      expect(episode.defaultsToVideo, isTrue);
    });

    test('has no video URL for an audio only episode', () {
      final episode = episodeWith([audioFileJson()]);

      expect(episode.videoProxyUrl, isNull);
      expect(episode.canSwitchVideo, isFalse);
      expect(episode.defaultsToVideo, isFalse);
    });

    test('names the downloaded file after the listened file', () {
      expect(episodeWith([audioFileJson(), videoFileJson()]).episodeFile, 'episode.mp3');
      expect(episodeWith([videoFileJson(defaultMedia: true)]).episodeFile, 'episode.mp4');
    });
  });

  group('EpisodeDownloads.fromOfflineJson', () {
    test('rebuilds the audio file of an episode downloaded before the media moved to the files', () {
      final json = createMockEpisodeJson()
        ..addAll({
          'audioUrl': 'http://example.com/legacy.mp3',
          'audioUrlEncrypted': 'legacy-encrypted',
          'audioType': 'audio/mpeg',
          'audioLengthBytes': 42,
        });

      final episode = EpisodeDownloads.fromOfflineJson(json);

      final audio = episode.audioFile!;
      expect(audio.url, 'http://example.com/legacy.mp3');
      expect(audio.urlEncrypted, 'legacy-encrypted');
      expect(audio.mime, 'audio/mpeg');
      expect(audio.lengthBytes, 42);
      expect(audio.defaultMedia, isTrue);
      expect(episode.episodeFile, 'episode.mp3');
    });

    test('keeps the files of an up to date episode', () {
      final json = createMockEpisodeJson(files: [audioFileJson(url: 'http://example.com/current.mp3')])
        ..['audioUrl'] = 'http://example.com/stale.mp3';

      final episode = EpisodeDownloads.fromOfflineJson(json);

      expect(episode.files, hasLength(1));
      expect(episode.audioFile?.url, 'http://example.com/current.mp3');
    });

    test('reads an episode without any media', () {
      final episode = EpisodeDownloads.fromOfflineJson(createMockEpisodeJson());

      expect(episode.audioFile, isNull);
    });
  });
}
