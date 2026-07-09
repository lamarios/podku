/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class SearchResult implements _i1.SerializableModel {
  SearchResult._({
    required this.artistName,
    this.feedUrl,
    this.artworkUrl600,
    this.trackViewUrl,
    this.trackName,
    this.collectionName,
  });

  factory SearchResult({
    required String artistName,
    String? feedUrl,
    String? artworkUrl600,
    String? trackViewUrl,
    String? trackName,
    String? collectionName,
  }) = _SearchResultImpl;

  factory SearchResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SearchResult(
      artistName: jsonSerialization['artistName'] as String,
      feedUrl: jsonSerialization['feedUrl'] as String?,
      artworkUrl600: jsonSerialization['artworkUrl600'] as String?,
      trackViewUrl: jsonSerialization['trackViewUrl'] as String?,
      trackName: jsonSerialization['trackName'] as String?,
      collectionName: jsonSerialization['collectionName'] as String?,
    );
  }

  String artistName;

  String? feedUrl;

  String? artworkUrl600;

  String? trackViewUrl;

  String? trackName;

  String? collectionName;

  /// Returns a shallow copy of this [SearchResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SearchResult copyWith({
    String? artistName,
    String? feedUrl,
    String? artworkUrl600,
    String? trackViewUrl,
    String? trackName,
    String? collectionName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SearchResult',
      'artistName': artistName,
      if (feedUrl != null) 'feedUrl': feedUrl,
      if (artworkUrl600 != null) 'artworkUrl600': artworkUrl600,
      if (trackViewUrl != null) 'trackViewUrl': trackViewUrl,
      if (trackName != null) 'trackName': trackName,
      if (collectionName != null) 'collectionName': collectionName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SearchResultImpl extends SearchResult {
  _SearchResultImpl({
    required String artistName,
    String? feedUrl,
    String? artworkUrl600,
    String? trackViewUrl,
    String? trackName,
    String? collectionName,
  }) : super._(
         artistName: artistName,
         feedUrl: feedUrl,
         artworkUrl600: artworkUrl600,
         trackViewUrl: trackViewUrl,
         trackName: trackName,
         collectionName: collectionName,
       );

  /// Returns a shallow copy of this [SearchResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SearchResult copyWith({
    String? artistName,
    Object? feedUrl = _Undefined,
    Object? artworkUrl600 = _Undefined,
    Object? trackViewUrl = _Undefined,
    Object? trackName = _Undefined,
    Object? collectionName = _Undefined,
  }) {
    return SearchResult(
      artistName: artistName ?? this.artistName,
      feedUrl: feedUrl is String? ? feedUrl : this.feedUrl,
      artworkUrl600: artworkUrl600 is String?
          ? artworkUrl600
          : this.artworkUrl600,
      trackViewUrl: trackViewUrl is String? ? trackViewUrl : this.trackViewUrl,
      trackName: trackName is String? ? trackName : this.trackName,
      collectionName: collectionName is String?
          ? collectionName
          : this.collectionName,
    );
  }
}
