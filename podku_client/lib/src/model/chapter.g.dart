// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChapterCWProxy {
  Chapter id(String? id);

  Chapter startTime(double? startTime);

  Chapter title(String? title);

  Chapter img(String? img);

  Chapter toc(bool? toc);

  Chapter endTime(double? endTime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Chapter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Chapter(...).copyWith(id: 12, name: "My name")
  /// ````
  Chapter call({
    String? id,
    double? startTime,
    String? title,
    String? img,
    bool? toc,
    double? endTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChapter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChapter.copyWith.fieldName(...)`
class _$ChapterCWProxyImpl implements _$ChapterCWProxy {
  const _$ChapterCWProxyImpl(this._value);

  final Chapter _value;

  @override
  Chapter id(String? id) => this(id: id);

  @override
  Chapter startTime(double? startTime) => this(startTime: startTime);

  @override
  Chapter title(String? title) => this(title: title);

  @override
  Chapter img(String? img) => this(img: img);

  @override
  Chapter toc(bool? toc) => this(toc: toc);

  @override
  Chapter endTime(double? endTime) => this(endTime: endTime);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Chapter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Chapter(...).copyWith(id: 12, name: "My name")
  /// ````
  Chapter call({
    Object? id = const $CopyWithPlaceholder(),
    Object? startTime = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? img = const $CopyWithPlaceholder(),
    Object? toc = const $CopyWithPlaceholder(),
    Object? endTime = const $CopyWithPlaceholder(),
  }) {
    return Chapter(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      startTime: startTime == const $CopyWithPlaceholder()
          ? _value.startTime
          // ignore: cast_nullable_to_non_nullable
          : startTime as double?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      img: img == const $CopyWithPlaceholder()
          ? _value.img
          // ignore: cast_nullable_to_non_nullable
          : img as String?,
      toc: toc == const $CopyWithPlaceholder()
          ? _value.toc
          // ignore: cast_nullable_to_non_nullable
          : toc as bool?,
      endTime: endTime == const $CopyWithPlaceholder()
          ? _value.endTime
          // ignore: cast_nullable_to_non_nullable
          : endTime as double?,
    );
  }
}

extension $ChapterCopyWith on Chapter {
  /// Returns a callable class that can be used as follows: `instanceOfChapter.copyWith(...)` or like so:`instanceOfChapter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChapterCWProxy get copyWith => _$ChapterCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Chapter', json, ($checkedConvert) {
      final val = Chapter(
        id: $checkedConvert('id', (v) => v as String?),
        startTime: $checkedConvert('startTime', (v) => (v as num?)?.toDouble()),
        title: $checkedConvert('title', (v) => v as String?),
        img: $checkedConvert('img', (v) => v as String?),
        toc: $checkedConvert('toc', (v) => v as bool?),
        endTime: $checkedConvert('endTime', (v) => (v as num?)?.toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
  'id': ?instance.id,
  'startTime': ?instance.startTime,
  'title': ?instance.title,
  'img': ?instance.img,
  'toc': ?instance.toc,
  'endTime': ?instance.endTime,
};
