// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_transcript.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EpisodeTranscriptCWProxy {
  EpisodeTranscript id(String? id);

  EpisodeTranscript startTime(String? startTime);

  EpisodeTranscript endTime(String? endTime);

  EpisodeTranscript speaker(String? speaker);

  EpisodeTranscript content(String? content);

  EpisodeTranscript language(String? language);

  EpisodeTranscript highlightedContent(String? highlightedContent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodeTranscript(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodeTranscript(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodeTranscript call({
    String? id,
    String? startTime,
    String? endTime,
    String? speaker,
    String? content,
    String? language,
    String? highlightedContent,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEpisodeTranscript.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEpisodeTranscript.copyWith.fieldName(...)`
class _$EpisodeTranscriptCWProxyImpl implements _$EpisodeTranscriptCWProxy {
  const _$EpisodeTranscriptCWProxyImpl(this._value);

  final EpisodeTranscript _value;

  @override
  EpisodeTranscript id(String? id) => this(id: id);

  @override
  EpisodeTranscript startTime(String? startTime) => this(startTime: startTime);

  @override
  EpisodeTranscript endTime(String? endTime) => this(endTime: endTime);

  @override
  EpisodeTranscript speaker(String? speaker) => this(speaker: speaker);

  @override
  EpisodeTranscript content(String? content) => this(content: content);

  @override
  EpisodeTranscript language(String? language) => this(language: language);

  @override
  EpisodeTranscript highlightedContent(String? highlightedContent) =>
      this(highlightedContent: highlightedContent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodeTranscript(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodeTranscript(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodeTranscript call({
    Object? id = const $CopyWithPlaceholder(),
    Object? startTime = const $CopyWithPlaceholder(),
    Object? endTime = const $CopyWithPlaceholder(),
    Object? speaker = const $CopyWithPlaceholder(),
    Object? content = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? highlightedContent = const $CopyWithPlaceholder(),
  }) {
    return EpisodeTranscript(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      startTime: startTime == const $CopyWithPlaceholder()
          ? _value.startTime
          // ignore: cast_nullable_to_non_nullable
          : startTime as String?,
      endTime: endTime == const $CopyWithPlaceholder()
          ? _value.endTime
          // ignore: cast_nullable_to_non_nullable
          : endTime as String?,
      speaker: speaker == const $CopyWithPlaceholder()
          ? _value.speaker
          // ignore: cast_nullable_to_non_nullable
          : speaker as String?,
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String?,
      highlightedContent: highlightedContent == const $CopyWithPlaceholder()
          ? _value.highlightedContent
          // ignore: cast_nullable_to_non_nullable
          : highlightedContent as String?,
    );
  }
}

extension $EpisodeTranscriptCopyWith on EpisodeTranscript {
  /// Returns a callable class that can be used as follows: `instanceOfEpisodeTranscript.copyWith(...)` or like so:`instanceOfEpisodeTranscript.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EpisodeTranscriptCWProxy get copyWith =>
      _$EpisodeTranscriptCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeTranscript _$EpisodeTranscriptFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EpisodeTranscript', json, ($checkedConvert) {
      final val = EpisodeTranscript(
        id: $checkedConvert('id', (v) => v as String?),
        startTime: $checkedConvert('startTime', (v) => v as String?),
        endTime: $checkedConvert('endTime', (v) => v as String?),
        speaker: $checkedConvert('speaker', (v) => v as String?),
        content: $checkedConvert('content', (v) => v as String?),
        language: $checkedConvert('language', (v) => v as String?),
        highlightedContent: $checkedConvert(
          'highlightedContent',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$EpisodeTranscriptToJson(EpisodeTranscript instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'startTime': ?instance.startTime,
      'endTime': ?instance.endTime,
      'speaker': ?instance.speaker,
      'content': ?instance.content,
      'language': ?instance.language,
      'highlightedContent': ?instance.highlightedContent,
    };
