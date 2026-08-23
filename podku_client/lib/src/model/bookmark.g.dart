// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookmarkCWProxy {
  Bookmark id(String? id);

  Bookmark time(int? time);

  Bookmark episode(Episode? episode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Bookmark(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Bookmark(...).copyWith(id: 12, name: "My name")
  /// ````
  Bookmark call({String? id, int? time, Episode? episode});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookmark.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookmark.copyWith.fieldName(...)`
class _$BookmarkCWProxyImpl implements _$BookmarkCWProxy {
  const _$BookmarkCWProxyImpl(this._value);

  final Bookmark _value;

  @override
  Bookmark id(String? id) => this(id: id);

  @override
  Bookmark time(int? time) => this(time: time);

  @override
  Bookmark episode(Episode? episode) => this(episode: episode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Bookmark(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Bookmark(...).copyWith(id: 12, name: "My name")
  /// ````
  Bookmark call({
    Object? id = const $CopyWithPlaceholder(),
    Object? time = const $CopyWithPlaceholder(),
    Object? episode = const $CopyWithPlaceholder(),
  }) {
    return Bookmark(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      time: time == const $CopyWithPlaceholder()
          ? _value.time
          // ignore: cast_nullable_to_non_nullable
          : time as int?,
      episode: episode == const $CopyWithPlaceholder()
          ? _value.episode
          // ignore: cast_nullable_to_non_nullable
          : episode as Episode?,
    );
  }
}

extension $BookmarkCopyWith on Bookmark {
  /// Returns a callable class that can be used as follows: `instanceOfBookmark.copyWith(...)` or like so:`instanceOfBookmark.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookmarkCWProxy get copyWith => _$BookmarkCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Bookmark', json, ($checkedConvert) {
      final val = Bookmark(
        id: $checkedConvert('id', (v) => v as String?),
        time: $checkedConvert('time', (v) => (v as num?)?.toInt()),
        episode: $checkedConvert(
          'episode',
          (v) => v == null ? null : Episode.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
  'id': ?instance.id,
  'time': ?instance.time,
  'episode': ?instance.episode?.toJson(),
};
