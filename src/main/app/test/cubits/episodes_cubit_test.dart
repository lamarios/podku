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
          (s) => s.episodeCount == 2 && s.episodes[EpisodeThresholds.older]?[0].title == 'Episode One',
        ),
      ),
    );

    expect(cubit.state.episodeCount, 2);
    expect(cubit.state.episodes[EpisodeThresholds.older]![1].title, 'Episode Two');
    expect(cubit.state.loading, isFalse);
    await cubit.close();
  });

  test('EpisodesCubit groups episodes by time frame', () async {
    final now = DateTime.now();
    final today = createMockEpisodeJson(id: 'ep-1', title: 'Today', pubDateMillis: now.millisecondsSinceEpoch);
    final pastWeek = createMockEpisodeJson(
      id: 'ep-2',
      title: 'Past week',
      pubDateMillis: now.subtract(const Duration(days: 3)).millisecondsSinceEpoch,
    );
    final older = createMockEpisodeJson(
      id: 'ep-3',
      title: 'Older',
      pubDateMillis: now.subtract(const Duration(days: 30)).millisecondsSinceEpoch,
    );

    nock(testServerUrl).get(startsWith('/api/episodes'))
      .reply(
        200,
        jsonEncode([today, pastWeek, older]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = EpisodesCubit(const EpisodesState());
    await expectLater(
      cubit.stream,
      emitsThrough(predicate<EpisodesState>((s) => s.episodeCount == 3)),
    );

    expect(cubit.state.episodes[EpisodeThresholds.today]!.map((e) => e.title), ['Today']);
    expect(cubit.state.episodes[EpisodeThresholds.pastWeek]!.map((e) => e.title), ['Past week']);
    expect(cubit.state.episodes[EpisodeThresholds.older]!.map((e) => e.title), ['Older']);
    expect(cubit.state.cursor, older['pubDateMillis']);
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
      emitsThrough(predicate<EpisodesState>((s) => s.episodeCount == 1)),
    );
    final previousOlder = cubit.state.episodes[EpisodeThresholds.older]!;

    // Load more mock
    nock(testServerUrl).get(startsWith('/api/episodes'))
      .reply(
        200,
        jsonEncode([ep2]),
        headers: {'content-type': 'application/json'},
      );

    final loadMoreFuture = expectLater(
      cubit.stream,
      emitsThrough(predicate<EpisodesState>((s) => s.episodeCount == 2)),
    );

    await cubit.loadMore();
    await loadMoreFuture;

    expect(cubit.state.episodeCount, 2);
    expect(cubit.state.episodes[EpisodeThresholds.older]!.last.title, 'Episode Two');
    expect(cubit.state.cursor, 500);
    // previous state must not have been mutated
    expect(previousOlder.length, 1);
    await cubit.close();
  });
}
