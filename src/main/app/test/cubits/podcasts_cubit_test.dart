import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  test('PodcastsCubit fetches podcasts successfully with nock', () async {
    nock(testServerUrl).get('/api/podcasts')
      .reply(
        200,
        jsonEncode([
          createMockPodcastLightJson(name: 'Podcast A'),
          createMockPodcastLightJson(name: 'Podcast B'),
        ]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = PodcastsCubit(PodcastState());

    // Wait for getPodcasts() from constructor to complete
    await expectLater(
      cubit.stream,
      emits(
        predicate<PodcastState>(
          (s) => s.subscriptions.length == 2 && s.subscriptions[0].name == 'Podcast A',
        ),
      ),
    );

    expect(cubit.state.subscriptions.length, 2);
    expect(cubit.state.subscriptions[1].name, 'Podcast B');
    await cubit.close();
  });

  test('PodcastsCubit subscribe adds subscription and refreshes', () async {
    // Initial fetch from constructor
    nock(testServerUrl).get('/api/podcasts')
      .reply(
        200,
        jsonEncode([]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = PodcastsCubit(PodcastState());
    await expectLater(cubit.stream, emits(predicate<PodcastState>((s) => s.subscriptions.isEmpty)));

    // Mock subscribe POST with any body matcher
    nock(testServerUrl).post('/api/podcasts', (dynamic _) => true)
      .reply(
        200,
        jsonEncode(createMockPodcastLightJson(name: 'New Show')),
        headers: {'content-type': 'application/json'},
      );

    // Mock subsequent getPodcasts GET
    nock(testServerUrl).get('/api/podcasts')
      .reply(
        200,
        jsonEncode([createMockPodcastLightJson(name: 'New Show')]),
        headers: {'content-type': 'application/json'},
      );

    final searchResult = SearchResult(
      feedUrl: 'http://example.com/new.xml',
      collectionName: 'New Show',
    );

    final future = expectLater(
      cubit.stream,
      emitsThrough(
        predicate<PodcastState>(
          (s) => s.subscriptions.length == 1 && s.subscriptions.first.name == 'New Show',
        ),
      ),
    );

    await cubit.subscribe(searchResult);
    await future;

    expect(cubit.state.subscriptions.length, 1);
    expect(cubit.state.subscriptions.first.name, 'New Show');
    await cubit.close();
  });
}
