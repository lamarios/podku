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

  EpisodeFile lengthBytes(int? lengthBytes);

  EpisodeFile bitrate(double? bitrate);

  EpisodeFile height(int? height);

  EpisodeFile title(String? title);

  EpisodeFile codecs(String? codecs);

  EpisodeFile defaultMedia(bool? defaultMedia);

  EpisodeFile urlEncrypted(String? urlEncrypted);

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
    int? lengthBytes,
    double? bitrate,
    int? height,
    String? title,
    String? codecs,
    bool? defaultMedia,
    String? urlEncrypted,
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
  EpisodeFile lengthBytes(int? lengthBytes) => this(lengthBytes: lengthBytes);

  @override
  EpisodeFile bitrate(double? bitrate) => this(bitrate: bitrate);

  @override
  EpisodeFile height(int? height) => this(height: height);

  @override
  EpisodeFile title(String? title) => this(title: title);

  @override
  EpisodeFile codecs(String? codecs) => this(codecs: codecs);

  @override
  EpisodeFile defaultMedia(bool? defaultMedia) =>
      this(defaultMedia: defaultMedia);

  @override
  EpisodeFile urlEncrypted(String? urlEncrypted) =>
      this(urlEncrypted: urlEncrypted);

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
    Object? lengthBytes = const $CopyWithPlaceholder(),
    Object? bitrate = const $CopyWithPlaceholder(),
    Object? height = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? codecs = const $CopyWithPlaceholder(),
    Object? defaultMedia = const $CopyWithPlaceholder(),
    Object? urlEncrypted = const $CopyWithPlaceholder(),
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
      lengthBytes: lengthBytes == const $CopyWithPlaceholder()
          ? _value.lengthBytes
          // ignore: cast_nullable_to_non_nullable
          : lengthBytes as int?,
      bitrate: bitrate == const $CopyWithPlaceholder()
          ? _value.bitrate
          // ignore: cast_nullable_to_non_nullable
          : bitrate as double?,
      height: height == const $CopyWithPlaceholder()
          ? _value.height
          // ignore: cast_nullable_to_non_nullable
          : height as int?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      codecs: codecs == const $CopyWithPlaceholder()
          ? _value.codecs
          // ignore: cast_nullable_to_non_nullable
          : codecs as String?,
      defaultMedia: defaultMedia == const $CopyWithPlaceholder()
          ? _value.defaultMedia
          // ignore: cast_nullable_to_non_nullable
          : defaultMedia as bool?,
      urlEncrypted: urlEncrypted == const $CopyWithPlaceholder()
          ? _value.urlEncrypted
          // ignore: cast_nullable_to_non_nullable
          : urlEncrypted as String?,
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

EpisodeFile _$EpisodeFileFromJson(Map<String, dynamic> json) => $checkedCreate(
  'EpisodeFile',
  json,
  ($checkedConvert) {
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
      lengthBytes: $checkedConvert('lengthBytes', (v) => (v as num?)?.toInt()),
      bitrate: $checkedConvert('bitrate', (v) => (v as num?)?.toDouble()),
      height: $checkedConvert('height', (v) => (v as num?)?.toInt()),
      title: $checkedConvert('title', (v) => v as String?),
      codecs: $checkedConvert('codecs', (v) => v as String?),
      defaultMedia: $checkedConvert('defaultMedia', (v) => v as bool?),
      urlEncrypted: $checkedConvert('urlEncrypted', (v) => v as String?),
    );
    return val;
  },
);

Map<String, dynamic> _$EpisodeFileToJson(EpisodeFile instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'url': ?instance.url,
      'type': ?_$EpisodeFileTypeEnumEnumMap[instance.type],
      'mime': ?instance.mime,
      'language': ?instance.language,
      'rel': ?instance.rel,
      'lengthBytes': ?instance.lengthBytes,
      'bitrate': ?instance.bitrate,
      'height': ?instance.height,
      'title': ?instance.title,
      'codecs': ?instance.codecs,
      'defaultMedia': ?instance.defaultMedia,
      'urlEncrypted': ?instance.urlEncrypted,
    };

const _$EpisodeFileTypeEnumEnumMap = {
  EpisodeFileTypeEnum.transcript: 'transcript',
  EpisodeFileTypeEnum.chapters: 'chapters',
  EpisodeFileTypeEnum.audio: 'audio',
  EpisodeFileTypeEnum.video: 'video',
};
