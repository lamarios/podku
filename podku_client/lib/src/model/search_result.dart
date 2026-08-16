//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SearchResult {
  /// Returns a new [SearchResult] instance.
  SearchResult({

     this.artworkUrlEncrypted,

     this.collectionId,

     this.collectionName,

     this.artistName,

     this.feedUrl,

     this.artworkUrl600,

     this.genres,

     this.color,
  });

  @JsonKey(
    
    name: r'artworkUrlEncrypted',
    required: false,
    includeIfNull: false,
  )


  final String? artworkUrlEncrypted;



  @JsonKey(
    
    name: r'collectionId',
    required: false,
    includeIfNull: false,
  )


  final int? collectionId;



  @JsonKey(
    
    name: r'collectionName',
    required: false,
    includeIfNull: false,
  )


  final String? collectionName;



  @JsonKey(
    
    name: r'artistName',
    required: false,
    includeIfNull: false,
  )


  final String? artistName;



  @JsonKey(
    
    name: r'feedUrl',
    required: false,
    includeIfNull: false,
  )


  final String? feedUrl;



  @JsonKey(
    
    name: r'artworkUrl600',
    required: false,
    includeIfNull: false,
  )


  final String? artworkUrl600;



  @JsonKey(
    
    name: r'genres',
    required: false,
    includeIfNull: false,
  )


  final List<String>? genres;



  @JsonKey(
    
    name: r'color',
    required: false,
    includeIfNull: false,
  )


  final String? color;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SearchResult &&
      other.artworkUrlEncrypted == artworkUrlEncrypted &&
      other.collectionId == collectionId &&
      other.collectionName == collectionName &&
      other.artistName == artistName &&
      other.feedUrl == feedUrl &&
      other.artworkUrl600 == artworkUrl600 &&
      other.genres == genres &&
      other.color == color;

    @override
    int get hashCode =>
        artworkUrlEncrypted.hashCode +
        collectionId.hashCode +
        collectionName.hashCode +
        artistName.hashCode +
        feedUrl.hashCode +
        artworkUrl600.hashCode +
        genres.hashCode +
        color.hashCode;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

