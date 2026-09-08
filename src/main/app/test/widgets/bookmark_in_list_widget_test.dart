import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/bookmarks/views/components/bookmark_in_list.dart';
import 'package:snaptest/snaptest.dart';
import '../test_helper.dart';

void main() {
  testWidgets('BookmarkInList displays episode title, topic and transcript snippet', (tester) async {
    final bookmark = BookmarkWithTranscript(
      bookmark: Bookmark(
        id: 'bm-1',
        time: 125,
        topic: 'State Management with BLoC',
        episode: Episode(
          id: 'ep-1',
          title: 'Episode 42: Flutter Architecture',
        ),
      ),
      transcripts: {
        'en': [
          EpisodeTranscript(
            id: 't-1',
            startTime: '00:02:00.000',
            endTime: '00:02:15.000',
            speaker: 'Alice',
            content: 'BLoC allows for predictable and testable state transitions.',
            language: 'en',
          ),
        ],
      },
    );

    await tester.pumpWidget(
      wrapWithMaterial(
        size: const Size(400, 300),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BookmarkInList(bookmark: bookmark),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Episode 42: Flutter Architecture'), findsOneWidget);
    expect(find.text('State Management with BLoC'), findsOneWidget);
    expect(
      find.text('BLoC allows for predictable and testable state transitions.'),
      findsOneWidget,
    );

    // Golden screenshot for this UI component
    await snap(name: 'bookmark_in_list_card', matchToGolden: true);
  });
}
