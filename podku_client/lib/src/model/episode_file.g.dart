// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_file.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EpisodeFileCWProxy {
  EpisodeFile id(String? id);

  EpisodeFile url(String? url);

  EpisodeFile type(EpisodeFileTypeEnum? type);

  EpisodeFile mime(String? mime);

  EpisodeFile language(String? language);

  EpisodeFile rel(String? rel);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodeFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodeFile(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodeFile call({
    String? id,
    String? url,
    EpisodeFileTypeEnum? type,
    String? mime,
    String? language,
    String? rel,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEpisodeFile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEpisodeFile.copyWith.fieldName(...)`
class _$EpisodeFileCWProxyImpl implements _$EpisodeFileCWProxy {
  const _$EpisodeFileCWProxyImpl(this._value);

  final EpisodeFile _value;

  @override
  EpisodeFile id(String? id) => this(id: id);

  @override
  EpisodeFile url(String? url) => this(url: url);

  @override
  EpisodeFile type(EpisodeFileTypeEnum? type) => this(type: type);

  @override
  EpisodeFile mime(String? mime) => this(mime: mime);

  @override
  EpisodeFile language(String? language) => this(language: language);

  @override
  EpisodeFile rel(String? rel) => this(rel: rel);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodeFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodeFile(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodeFile call({
    Object? id = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? rel = const $CopyWithPlaceholder(),
  }) {
    return EpisodeFile(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as EpisodeFileTypeEnum?,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String?,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String?,
      rel: rel == const $CopyWithPlaceholder()
          ? _value.rel
          // ignore: cast_nullable_to_non_nullable
          : rel as String?,
    );
  }
}

extension $EpisodeFileCopyWith on EpisodeFile {
  /// Returns a callable class that can be used as follows: `instanceOfEpisodeFile.copyWith(...)` or like so:`instanceOfEpisodeFile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EpisodeFileCWProxy get copyWith => _$EpisodeFileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeFile _$EpisodeFileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EpisodeFile', json, ($checkedConvert) {
      final val = EpisodeFile(
        id: $checkedConvert('id', (v) => v as String?),
        url: $checkedConvert('url', (v) => v as String?),
        type: $checkedConvert(
          'type',
          (v) => $enumDecodeNullable(_$EpisodeFileTypeEnumEnumMap, v),
        ),
        mime: $checkedConvert('mime', (v) => v as String?),
        language: $checkedConvert('language', (v) => v as String?),
        rel: $checkedConvert('rel', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$EpisodeFileToJson(EpisodeFile instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'url': ?instance.url,
      'type': ?_$EpisodeFileTypeEnumEnumMap[instance.type],
      'mime': ?instance.mime,
      'language': ?instance.language,
      'rel': ?instance.rel,
    };

const _$EpisodeFileTypeEnumEnumMap = {
  EpisodeFileTypeEnum.transcript: 'transcript',
  EpisodeFileTypeEnum.chapters: 'chapters',
};
