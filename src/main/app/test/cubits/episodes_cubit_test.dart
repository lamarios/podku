import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:podku/episodes/states/episodes.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  test('EpisodesCubit fetches episodes successfully with nock', () async {
    final ep1 = createMockEpisodeJson(id: 'ep-1', title: 'Episode One');
    final ep2 = createMockEpisodeJson(id: 'ep-2', title: 'Episode Two');

    nock(testServerUrl).get(startsWith('/api/episodes'))
      .reply(
        200,
        jsonEncode([ep1, ep2]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = EpisodesCubit(const EpisodesState());

    await expectLater(
      cubit.stream,
      emitsThrough(
        predicate<EpisodesState>(
          (s) => s.episodes.length == 2 && s.episodes[0].title == 'Episode One',
        ),
      ),
    );

    expect(cubit.state.episodes.length, 2);
    expect(cubit.state.episodes[1].title, 'Episode Two');
    expect(cubit.state.loading, isFalse);
    await cubit.close();
  });

  test('EpisodesCubit loadMore appends additional episodes', () async {
    final ep1 = createMockEpisodeJson(id: 'ep-1', title: 'Episode One', pubDateMillis: 1000);
    final ep2 = createMockEpisodeJson(id: 'ep-2', title: 'Episode Two', pubDateMillis: 500);

    // Initial load
    nock(testServerUrl).get(startsWith('/api/episodes'))
      .reply(
        200,
        jsonEncode([ep1]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = EpisodesCubit(const EpisodesState());
    await expectLater(
      cubit.stream,
      emitsThrough(predicate<EpisodesState>((s) => s.episodes.length == 1)),
    );

    // Load more mock
    nock(testServerUrl).get(startsWith('/api/episodes'))
      .reply(
        200,
        jsonEncode([ep2]),
        headers: {'content-type': 'application/json'},
      );

    final loadMoreFuture = expectLater(
      cubit.stream,
      emitsThrough(predicate<EpisodesState>((s) => s.episodes.length == 2)),
    );

    await cubit.loadMore();
    await loadMoreFuture;

    expect(cubit.state.episodes.length, 2);
    expect(cubit.state.episodes.last.title, 'Episode Two');
    await cubit.close();
  });
}
