// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_search_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EpisodeSearchResultCWProxy {
  EpisodeSearchResult episode(Episode? episode);

  EpisodeSearchResult matchedTranscripts(
    List<EpisodeTranscript>? matchedTranscripts,
  );

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodeSearchResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodeSearchResult(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodeSearchResult call({
    Episode? episode,
    List<EpisodeTranscript>? matchedTranscripts,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEpisodeSearchResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEpisodeSearchResult.copyWith.fieldName(...)`
class _$EpisodeSearchResultCWProxyImpl implements _$EpisodeSearchResultCWProxy {
  const _$EpisodeSearchResultCWProxyImpl(this._value);

  final EpisodeSearchResult _value;

  @override
  EpisodeSearchResult episode(Episode? episode) => this(episode: episode);

  @override
  EpisodeSearchResult matchedTranscripts(
    List<EpisodeTranscript>? matchedTranscripts,
  ) => this(matchedTranscripts: matchedTranscripts);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodeSearchResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodeSearchResult(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodeSearchResult call({
    Object? episode = const $CopyWithPlaceholder(),
    Object? matchedTranscripts = const $CopyWithPlaceholder(),
  }) {
    return EpisodeSearchResult(
      episode: episode == const $CopyWithPlaceholder()
          ? _value.episode
          // ignore: cast_nullable_to_non_nullable
          : episode as Episode?,
      matchedTranscripts: matchedTranscripts == const $CopyWithPlaceholder()
          ? _value.matchedTranscripts
          // ignore: cast_nullable_to_non_nullable
          : matchedTranscripts as List<EpisodeTranscript>?,
    );
  }
}

extension $EpisodeSearchResultCopyWith on EpisodeSearchResult {
  /// Returns a callable class that can be used as follows: `instanceOfEpisodeSearchResult.copyWith(...)` or like so:`instanceOfEpisodeSearchResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EpisodeSearchResultCWProxy get copyWith =>
      _$EpisodeSearchResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeSearchResult _$EpisodeSearchResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EpisodeSearchResult', json, ($checkedConvert) {
      final val = EpisodeSearchResult(
        episode: $checkedConvert(
          'episode',
          (v) => v == null ? null : Episode.fromJson(v as Map<String, dynamic>),
        ),
        matchedTranscripts: $checkedConvert(
          'matchedTranscripts',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => EpisodeTranscript.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EpisodeSearchResultToJson(
  EpisodeSearchResult instance,
) => <String, dynamic>{
  'episode': ?instance.episode?.toJson(),
  'matchedTranscripts': ?instance.matchedTranscripts
      ?.map((e) => e.toJson())
      .toList(),
};
