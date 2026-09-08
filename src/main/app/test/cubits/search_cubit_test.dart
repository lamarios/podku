import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:podku/search/states/search.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  test('SearchCubit searches podcasts, episodes and itunes directory', () async {
    final mockDiscoverResult = {
      'collectionName': 'Discover Show',
      'feedUrl': 'http://example.com/discover.xml',
    };

    final mockPodcastResult = createMockPodcastLightJson(name: 'Subscribed Tech');

    final mockEpisodeResult = {
      'episode': createMockEpisodeJson(title: 'Found Episode'),
      'matchedTranscripts': [],
    };

    nock(testServerUrl).get(startsWith('/api/search'))
      .reply(
        200,
        jsonEncode([mockDiscoverResult]),
        headers: {'content-type': 'application/json'},
      );

    nock(testServerUrl).get(startsWith('/api/podcasts/search'))
      .reply(
        200,
        jsonEncode([mockPodcastResult]),
        headers: {'content-type': 'application/json'},
      );

    nock(testServerUrl).get(startsWith('/api/episodes/search'))
      .reply(
        200,
        jsonEncode([mockEpisodeResult]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = SearchCubit(const SearchState(), 'flutter');

    // Wait for 500ms debounce and response handling
    await expectLater(
      cubit.stream,
      emitsThrough(
        predicate<SearchState>(
          (s) =>
              s.discoverResults.isNotEmpty &&
              s.podcastResults.isNotEmpty &&
              s.episodeResults.isNotEmpty,
        ),
      ),
    );

    expect(cubit.state.discoverResults.first.collectionName, 'Discover Show');
    expect(cubit.state.podcastResults.first.name, 'Subscribed Tech');
    expect(cubit.state.episodeResults.first.episode?.title, 'Found Episode');

    await cubit.close();
  });
}
