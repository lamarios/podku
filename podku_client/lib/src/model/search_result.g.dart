// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SearchResultCWProxy {
  SearchResult collectionId(int? collectionId);

  SearchResult collectionName(String? collectionName);

  SearchResult artistName(String? artistName);

  SearchResult feedUrl(String? feedUrl);

  SearchResult artworkUrl600(String? artworkUrl600);

  SearchResult genres(List<String>? genres);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchResult(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchResult call({
    int? collectionId,
    String? collectionName,
    String? artistName,
    String? feedUrl,
    String? artworkUrl600,
    List<String>? genres,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSearchResult.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSearchResult.copyWith.fieldName(...)`
class _$SearchResultCWProxyImpl implements _$SearchResultCWProxy {
  const _$SearchResultCWProxyImpl(this._value);

  final SearchResult _value;

  @override
  SearchResult collectionId(int? collectionId) =>
      this(collectionId: collectionId);

  @override
  SearchResult collectionName(String? collectionName) =>
      this(collectionName: collectionName);

  @override
  SearchResult artistName(String? artistName) => this(artistName: artistName);

  @override
  SearchResult feedUrl(String? feedUrl) => this(feedUrl: feedUrl);

  @override
  SearchResult artworkUrl600(String? artworkUrl600) =>
      this(artworkUrl600: artworkUrl600);

  @override
  SearchResult genres(List<String>? genres) => this(genres: genres);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SearchResult(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SearchResult(...).copyWith(id: 12, name: "My name")
  /// ````
  SearchResult call({
    Object? collectionId = const $CopyWithPlaceholder(),
    Object? collectionName = const $CopyWithPlaceholder(),
    Object? artistName = const $CopyWithPlaceholder(),
    Object? feedUrl = const $CopyWithPlaceholder(),
    Object? artworkUrl600 = const $CopyWithPlaceholder(),
    Object? genres = const $CopyWithPlaceholder(),
  }) {
    return SearchResult(
      collectionId: collectionId == const $CopyWithPlaceholder()
          ? _value.collectionId
          // ignore: cast_nullable_to_non_nullable
          : collectionId as int?,
      collectionName: collectionName == const $CopyWithPlaceholder()
          ? _value.collectionName
          // ignore: cast_nullable_to_non_nullable
          : collectionName as String?,
      artistName: artistName == const $CopyWithPlaceholder()
          ? _value.artistName
          // ignore: cast_nullable_to_non_nullable
          : artistName as String?,
      feedUrl: feedUrl == const $CopyWithPlaceholder()
          ? _value.feedUrl
          // ignore: cast_nullable_to_non_nullable
          : feedUrl as String?,
      artworkUrl600: artworkUrl600 == const $CopyWithPlaceholder()
          ? _value.artworkUrl600
          // ignore: cast_nullable_to_non_nullable
          : artworkUrl600 as String?,
      genres: genres == const $CopyWithPlaceholder()
          ? _value.genres
          // ignore: cast_nullable_to_non_nullable
          : genres as List<String>?,
    );
  }
}

extension $SearchResultCopyWith on SearchResult {
  /// Returns a callable class that can be used as follows: `instanceOfSearchResult.copyWith(...)` or like so:`instanceOfSearchResult.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SearchResultCWProxy get copyWith => _$SearchResultCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SearchResult', json, ($checkedConvert) {
      final val = SearchResult(
        collectionId: $checkedConvert(
          'collectionId',
          (v) => (v as num?)?.toInt(),
        ),
        collectionName: $checkedConvert('collectionName', (v) => v as String?),
        artistName: $checkedConvert('artistName', (v) => v as String?),
        feedUrl: $checkedConvert('feedUrl', (v) => v as String?),
        artworkUrl600: $checkedConvert('artworkUrl600', (v) => v as String?),
        genres: $checkedConvert(
          'genres',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'collectionId': ?instance.collectionId,
      'collectionName': ?instance.collectionName,
      'artistName': ?instance.artistName,
      'feedUrl': ?instance.feedUrl,
      'artworkUrl600': ?instance.artworkUrl600,
      'genres': ?instance.genres,
    };
