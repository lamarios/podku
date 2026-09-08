import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/foundations/m3e_icons.dart';
import 'package:nock/nock.dart';
import 'package:podku/bookmarks/views/components/bookmark_in_list.dart';
import 'package:podku/bookmarks/views/screens/bookmarks_screen.dart';
import 'package:snaptest/snaptest.dart';
import '../test_helper.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
    setupTestGetIt();
  });

  testWidgets('BookmarksScreen renders empty state when no bookmarks exist', (tester) async {
    nock(testServerUrl).get('/api/bookmarks')
      .reply(
        200,
        jsonEncode([]),
        headers: {'content-type': 'application/json'},
      );

    await tester.pumpWidget(
      wrapWithMaterial(
        size: const Size(400, 700),
        child: const BookmarksScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BookmarkInList), findsNothing);
    expect(find.byIcon(M3EIcons.bookmark), findsOneWidget);
    expect(find.byIcon(M3EIcons.add), findsOneWidget);

    // Golden screenshot for empty state UI
    await snap(name: 'bookmarks_screen_empty', matchToGolden: true);
  });

  testWidgets('BookmarksScreen renders bookmarks from nock mock', (tester) async {
    final b1 = createMockBookmarkWithTranscriptJson(
      bookmarkId: 'bm-1',
      topic: 'Intro to Flutter BLoC',
    );
    final b2 = createMockBookmarkWithTranscriptJson(
      bookmarkId: 'bm-2',
      topic: 'Testing with Testcontainers',
    );

    nock(testServerUrl).get('/api/bookmarks')
      .reply(
        200,
        jsonEncode([b1, b2]),
        headers: {'content-type': 'application/json'},
      );

    await tester.pumpWidget(
      wrapWithMaterial(
        size: const Size(400, 700),
        child: const BookmarksScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BookmarkInList), findsNWidgets(2));
    expect(find.text('Intro to Flutter BLoC'), findsOneWidget);
    expect(find.text('Testing with Testcontainers'), findsOneWidget);

    // Golden screenshot for populated bookmarks list UI
    await snap(name: 'bookmarks_screen_populated', matchToGolden: true);

    // Let CacheStore cleanup timer elapse
    await tester.pump(const Duration(seconds: 15));
  });
}
