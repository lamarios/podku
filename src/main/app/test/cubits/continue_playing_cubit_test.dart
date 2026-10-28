import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:podku/episodes/states/continue_playing.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  void mockInProgress(List<Map<String, dynamic>> episodes) {
    nock(testServerUrl).get(startsWith('/api/episodes/inProgress'))
      .reply(
        200,
        jsonEncode(episodes),
        headers: {'content-type': 'application/json'},
      );
  }

  void mockInProgressError() {
    nock(testServerUrl).get(startsWith('/api/episodes/inProgress')).reply(500, 'Internal Server Error');
  }

  test('ContinuePlayingCubit exposes the error and stops loading when the request fails', () async {
    mockInProgressError();

    final cubit = ContinuePlayingCubit(const ContinuePlayingState());
    await expectLater(
      cubit.stream,
      emitsThrough(predicate<ContinuePlayingState>((s) => s.error != null)),
    );

    expect(cubit.state.loading, isFalse);
    expect(cubit.state.episodes, isEmpty);
    expect(cubit.state.stackTrace, isNotNull);
    await cubit.close();
  });

  test('ContinuePlayingCubit keeps loaded episodes when a refresh fails', () async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    final cubit = ContinuePlayingCubit(const ContinuePlayingState());
    await expectLater(
      cubit.stream,
      emitsThrough(predicate<ContinuePlayingState>((s) => !s.loading)),
    );

    mockInProgressError();
    await cubit.getEpisodes(loading: false);

    expect(cubit.state.error, isNotNull);
    expect(cubit.state.loading, isFalse);
    expect(cubit.state.episodes.map((e) => e.title), ['Episode One']);
    await cubit.close();
  });

  test('ContinuePlayingCubit fetches in progress episodes on creation', () async {
    mockInProgress([
      createMockEpisodeJson(id: 'ep-1', title: 'Episode One', progress: 120),
      createMockEpisodeJson(id: 'ep-2', title: 'Episode Two', progress: 600),
    ]);

    final cubit = ContinuePlayingCubit(const ContinuePlayingState());
    expect(cubit.state.loading, isTrue);

    await expectLater(
      cubit.stream,
      emitsThrough(predicate<ContinuePlayingState>((s) => !s.loading)),
    );

    expect(cubit.state.episodes.map((e) => e.title), ['Episode One', 'Episode Two']);
    await cubit.close();
  });

  test('ContinuePlayingCubit silent refresh does not show loading', () async {
    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    final cubit = ContinuePlayingCubit(const ContinuePlayingState());
    await expectLater(
      cubit.stream,
      emitsThrough(predicate<ContinuePlayingState>((s) => !s.loading)),
    );

    mockInProgress([
      createMockEpisodeJson(id: 'ep-1', title: 'Episode One'),
      createMockEpisodeJson(id: 'ep-2', title: 'Episode Two'),
    ]);

    final states = <ContinuePlayingState>[];
    final sub = cubit.stream.listen(states.add);
    await cubit.getEpisodes(loading: false);
    await sub.cancel();

    expect(states.any((s) => s.loading), isFalse);
    expect(cubit.state.episodes.length, 2);
    await cubit.close();
  });

  test('ContinuePlayingCubit refresh with loading shows loading', () async {
    mockInProgress([]);

    final cubit = ContinuePlayingCubit(const ContinuePlayingState());
    await expectLater(
      cubit.stream,
      emitsThrough(predicate<ContinuePlayingState>((s) => !s.loading)),
    );
    expect(cubit.state.episodes, isEmpty);

    mockInProgress([createMockEpisodeJson(id: 'ep-1', title: 'Episode One')]);

    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        predicate<ContinuePlayingState>((s) => s.loading),
        predicate<ContinuePlayingState>((s) => !s.loading && s.episodes.length == 1),
      ]),
    );
    await cubit.getEpisodes();
    await expectation;
    await cubit.close();
  });
}
