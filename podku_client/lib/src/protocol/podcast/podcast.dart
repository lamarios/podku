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
import '../podcast/episode.dart' as _i2;
import 'package:podku_client/src/protocol/protocol.dart' as _i3;

abstract class Podcast implements _i1.SerializableModel {
  Podcast._({
    _i1.UuidValue? id,
    required this.url,
    required this.name,
    this.artworkUrl,
    this.description,
    this.author,
    this.link,
    this.episodes,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory Podcast({
    _i1.UuidValue? id,
    required String url,
    required String name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<_i2.Episode>? episodes,
  }) = _PodcastImpl;

  factory Podcast.fromJson(Map<String, dynamic> jsonSerialization) {
    return Podcast(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      url: jsonSerialization['url'] as String,
      name: jsonSerialization['name'] as String,
      artworkUrl: jsonSerialization['artworkUrl'] as String?,
      description: jsonSerialization['description'] as String?,
      author: jsonSerialization['author'] as String?,
      link: jsonSerialization['link'] as String?,
      episodes: jsonSerialization['episodes'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.Episode>>(
              jsonSerialization['episodes'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  String url;

  String name;

  String? artworkUrl;

  String? description;

  String? author;

  String? link;

  List<_i2.Episode>? episodes;

  /// Returns a shallow copy of this [Podcast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Podcast copyWith({
    _i1.UuidValue? id,
    String? url,
    String? name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<_i2.Episode>? episodes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Podcast',
      'id': id.toJson(),
      'url': url,
      'name': name,
      if (artworkUrl != null) 'artworkUrl': artworkUrl,
      if (description != null) 'description': description,
      if (author != null) 'author': author,
      if (link != null) 'link': link,
      if (episodes != null)
        'episodes': episodes?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PodcastImpl extends Podcast {
  _PodcastImpl({
    _i1.UuidValue? id,
    required String url,
    required String name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<_i2.Episode>? episodes,
  }) : super._(
         id: id,
         url: url,
         name: name,
         artworkUrl: artworkUrl,
         description: description,
         author: author,
         link: link,
         episodes: episodes,
       );

  /// Returns a shallow copy of this [Podcast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Podcast copyWith({
    _i1.UuidValue? id,
    String? url,
    String? name,
    Object? artworkUrl = _Undefined,
    Object? description = _Undefined,
    Object? author = _Undefined,
    Object? link = _Undefined,
    Object? episodes = _Undefined,
  }) {
    return Podcast(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      artworkUrl: artworkUrl is String? ? artworkUrl : this.artworkUrl,
      description: description is String? ? description : this.description,
      author: author is String? ? author : this.author,
      link: link is String? ? link : this.link,
      episodes: episodes is List<_i2.Episode>?
          ? episodes
          : this.episodes?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
