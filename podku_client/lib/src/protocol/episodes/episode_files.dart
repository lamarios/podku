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
import '../episodes/episode_file_type.dart' as _i2;
import '../podcast/episode.dart' as _i3;
import 'package:podku_client/src/protocol/protocol.dart' as _i4;

abstract class EpisodeFile implements _i1.SerializableModel {
  EpisodeFile._({
    _i1.UuidValue? id,
    required this.type,
    this.mime,
    required this.url,
    this.language,
    this.rel,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory EpisodeFile({
    _i1.UuidValue? id,
    required _i2.EpisodeFileType type,
    String? mime,
    required String url,
    String? language,
    String? rel,
    required _i1.UuidValue episodeId,
    _i3.Episode? episode,
  }) = _EpisodeFileImpl;

  factory EpisodeFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodeFile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      type: _i2.EpisodeFileType.fromJson((jsonSerialization['type'] as String)),
      mime: jsonSerialization['mime'] as String?,
      url: jsonSerialization['url'] as String,
      language: jsonSerialization['language'] as String?,
      rel: jsonSerialization['rel'] as String?,
      episodeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['episodeId'],
      ),
      episode: jsonSerialization['episode'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Episode>(
              jsonSerialization['episode'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i2.EpisodeFileType type;

  String? mime;

  String url;

  String? language;

  String? rel;

  _i1.UuidValue episodeId;

  _i3.Episode? episode;

  /// Returns a shallow copy of this [EpisodeFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EpisodeFile copyWith({
    _i1.UuidValue? id,
    _i2.EpisodeFileType? type,
    String? mime,
    String? url,
    String? language,
    String? rel,
    _i1.UuidValue? episodeId,
    _i3.Episode? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EpisodeFile',
      'id': id.toJson(),
      'type': type.toJson(),
      if (mime != null) 'mime': mime,
      'url': url,
      if (language != null) 'language': language,
      if (rel != null) 'rel': rel,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EpisodeFileImpl extends EpisodeFile {
  _EpisodeFileImpl({
    _i1.UuidValue? id,
    required _i2.EpisodeFileType type,
    String? mime,
    required String url,
    String? language,
    String? rel,
    required _i1.UuidValue episodeId,
    _i3.Episode? episode,
  }) : super._(
         id: id,
         type: type,
         mime: mime,
         url: url,
         language: language,
         rel: rel,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [EpisodeFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EpisodeFile copyWith({
    _i1.UuidValue? id,
    _i2.EpisodeFileType? type,
    Object? mime = _Undefined,
    String? url,
    Object? language = _Undefined,
    Object? rel = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return EpisodeFile(
      id: id ?? this.id,
      type: type ?? this.type,
      mime: mime is String? ? mime : this.mime,
      url: url ?? this.url,
      language: language is String? ? language : this.language,
      rel: rel is String? ? rel : this.rel,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i3.Episode? ? episode : this.episode?.copyWith(),
    );
  }
}
