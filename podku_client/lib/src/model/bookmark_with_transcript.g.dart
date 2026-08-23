// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_with_transcript.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookmarkWithTranscriptCWProxy {
  BookmarkWithTranscript bookmark(Bookmark? bookmark);

  BookmarkWithTranscript transcripts(
    Map<String, List<EpisodeTranscript>>? transcripts,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookmarkWithTranscript(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookmarkWithTranscript(...).copyWith(id: 12, name: "My name")
  /// ````
  BookmarkWithTranscript call({
    Bookmark? bookmark,
    Map<String, List<EpisodeTranscript>>? transcripts,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookmarkWithTranscript.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookmarkWithTranscript.copyWith.fieldName(...)`
class _$BookmarkWithTranscriptCWProxyImpl
    implements _$BookmarkWithTranscriptCWProxy {
  const _$BookmarkWithTranscriptCWProxyImpl(this._value);

  final BookmarkWithTranscript _value;

  @override
  BookmarkWithTranscript bookmark(Bookmark? bookmark) =>
      this(bookmark: bookmark);

  @override
  BookmarkWithTranscript transcripts(
    Map<String, List<EpisodeTranscript>>? transcripts,
  ) => this(transcripts: transcripts);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookmarkWithTranscript(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookmarkWithTranscript(...).copyWith(id: 12, name: "My name")
  /// ````
  BookmarkWithTranscript call({
    Object? bookmark = const $CopyWithPlaceholder(),
    Object? transcripts = const $CopyWithPlaceholder(),
  }) {
    return BookmarkWithTranscript(
      bookmark: bookmark == const $CopyWithPlaceholder()
          ? _value.bookmark
          // ignore: cast_nullable_to_non_nullable
          : bookmark as Bookmark?,
      transcripts: transcripts == const $CopyWithPlaceholder()
          ? _value.transcripts
          // ignore: cast_nullable_to_non_nullable
          : transcripts as Map<String, List<EpisodeTranscript>>?,
    );
  }
}

extension $BookmarkWithTranscriptCopyWith on BookmarkWithTranscript {
  /// Returns a callable class that can be used as follows: `instanceOfBookmarkWithTranscript.copyWith(...)` or like so:`instanceOfBookmarkWithTranscript.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookmarkWithTranscriptCWProxy get copyWith =>
      _$BookmarkWithTranscriptCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkWithTranscript _$BookmarkWithTranscriptFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BookmarkWithTranscript', json, ($checkedConvert) {
  final val = BookmarkWithTranscript(
    bookmark: $checkedConvert(
      'bookmark',
      (v) => v == null ? null : Bookmark.fromJson(v as Map<String, dynamic>),
    ),
    transcripts: $checkedConvert(
      'transcripts',
      (v) => (v as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => EpisodeTranscript.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    ),
  );
  return val;
});

Map<String, dynamic> _$BookmarkWithTranscriptToJson(
  BookmarkWithTranscript instance,
) => <String, dynamic>{
  'bookmark': ?instance.bookmark?.toJson(),
  'transcripts': ?instance.transcripts?.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};
