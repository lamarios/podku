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
import '../podcast/podcast.dart' as _i2;
import 'package:podku_client/src/protocol/protocol.dart' as _i3;

abstract class PodcastPerson implements _i1.SerializableModel {
  PodcastPerson._({
    _i1.UuidValue? id,
    required this.name,
    this.role,
    this.group,
    this.image,
    this.link,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory PodcastPerson({
    _i1.UuidValue? id,
    required String name,
    String? role,
    String? group,
    String? image,
    String? link,
    required _i1.UuidValue episodeId,
    _i2.Podcast? episode,
  }) = _PodcastPersonImpl;

  factory PodcastPerson.fromJson(Map<String, dynamic> jsonSerialization) {
    return PodcastPerson(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      role: jsonSerialization['role'] as String?,
      group: jsonSerialization['group'] as String?,
      image: jsonSerialization['image'] as String?,
      link: jsonSerialization['link'] as String?,
      episodeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['episodeId'],
      ),
      episode: jsonSerialization['episode'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Podcast>(
              jsonSerialization['episode'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  String name;

  String? role;

  String? group;

  String? image;

  String? link;

  _i1.UuidValue episodeId;

  _i2.Podcast? episode;

  /// Returns a shallow copy of this [PodcastPerson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PodcastPerson copyWith({
    _i1.UuidValue? id,
    String? name,
    String? role,
    String? group,
    String? image,
    String? link,
    _i1.UuidValue? episodeId,
    _i2.Podcast? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PodcastPerson',
      'id': id.toJson(),
      'name': name,
      if (role != null) 'role': role,
      if (group != null) 'group': group,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
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

class _PodcastPersonImpl extends PodcastPerson {
  _PodcastPersonImpl({
    _i1.UuidValue? id,
    required String name,
    String? role,
    String? group,
    String? image,
    String? link,
    required _i1.UuidValue episodeId,
    _i2.Podcast? episode,
  }) : super._(
         id: id,
         name: name,
         role: role,
         group: group,
         image: image,
         link: link,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [PodcastPerson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PodcastPerson copyWith({
    _i1.UuidValue? id,
    String? name,
    Object? role = _Undefined,
    Object? group = _Undefined,
    Object? image = _Undefined,
    Object? link = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return PodcastPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role is String? ? role : this.role,
      group: group is String? ? group : this.group,
      image: image is String? ? image : this.image,
      link: link is String? ? link : this.link,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i2.Podcast? ? episode : this.episode?.copyWith(),
    );
  }
}
