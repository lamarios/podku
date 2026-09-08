import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';
import 'package:podku/bookmarks/states/bookmark.dart';
import 'package:podku/bookmarks/states/bookmarks.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  test('BookmarksCubit fetches bookmarks successfully with nock', () async {
    final b1 = createMockBookmarkWithTranscriptJson(bookmarkId: 'bm-1', topic: 'Topic 1');
    final b2 = createMockBookmarkWithTranscriptJson(bookmarkId: 'bm-2', topic: 'Topic 2');

    nock(testServerUrl).get('/api/bookmarks')
      .reply(
        200,
        jsonEncode([b1, b2]),
        headers: {'content-type': 'application/json'},
      );

    final cubit = BookmarksCubit(const BookmarksState());

    await expectLater(
      cubit.stream,
      emitsThrough(
        predicate<BookmarksState>(
          (s) => s.bookmarks.length == 2 && s.bookmarks[0].bookmark?.topic == 'Topic 1',
        ),
      ),
    );

    expect(cubit.state.bookmarks.length, 2);
    expect(cubit.state.bookmarks[1].bookmark?.topic, 'Topic 2');
    expect(cubit.state.loading, isFalse);
    await cubit.close();
  });

  test('BookmarkCubit fetches single bookmark and deletes with nock', () async {
    const bookmarkId = 'bm-single-1';
    final mockBookmark = createMockBookmarkWithTranscriptJson(
      bookmarkId: bookmarkId,
      topic: 'Detailed Topic',
    );

    nock(testServerUrl).get('/api/bookmarks/$bookmarkId')
      .reply(
        200,
        jsonEncode(mockBookmark),
        headers: {'content-type': 'application/json'},
      );

    final cubit = BookmarkCubit(const BookmarkState(), bookmarkId: bookmarkId);

    await expectLater(
      cubit.stream,
      emitsThrough(
        predicate<BookmarkState>(
          (s) => s.bookmark?.bookmark?.id == bookmarkId && !s.loading,
        ),
      ),
    );

    expect(cubit.state.bookmark?.bookmark?.topic, 'Detailed Topic');

    // Test delete
    final deleteInterceptor = nock(testServerUrl).delete('/api/bookmarks/$bookmarkId');
    deleteInterceptor.reply(200, '');

    await cubit.delete();
    expect(deleteInterceptor.isDone, isTrue);

    await cubit.close();
  });
}
