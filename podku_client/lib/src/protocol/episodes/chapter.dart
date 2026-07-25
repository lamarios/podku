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

abstract class Chapter implements _i1.SerializableModel {
  Chapter._({
    _i1.UuidValue? id,
    required this.startTime,
    this.title,
    this.img,
    bool? toc,
    this.endTime,
    this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj(),
       toc = toc ?? true;

  factory Chapter({
    _i1.UuidValue? id,
    required double startTime,
    String? title,
    String? img,
    bool? toc,
    double? endTime,
    _i1.UuidValue? episodeId,
    _i2.Episode? episode,
  }) = _ChapterImpl;

  factory Chapter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Chapter(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      startTime: (jsonSerialization['startTime'] as num).toDouble(),
      title: jsonSerialization['title'] as String?,
      img: jsonSerialization['img'] as String?,
      toc: jsonSerialization['toc'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['toc']),
      endTime: (jsonSerialization['endTime'] as num?)?.toDouble(),
      episodeId: jsonSerialization['episodeId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['episodeId']),
      episode: jsonSerialization['episode'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Episode>(
              jsonSerialization['episode'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  double startTime;

  String? title;

  String? img;

  bool toc;

  double? endTime;

  _i1.UuidValue? episodeId;

  _i2.Episode? episode;

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Chapter copyWith({
    _i1.UuidValue? id,
    double? startTime,
    String? title,
    String? img,
    bool? toc,
    double? endTime,
    _i1.UuidValue? episodeId,
    _i2.Episode? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Chapter',
      'id': id.toJson(),
      'startTime': startTime,
      if (title != null) 'title': title,
      if (img != null) 'img': img,
      'toc': toc,
      if (endTime != null) 'endTime': endTime,
      if (episodeId != null) 'episodeId': episodeId?.toJson(),
      if (episode != null) 'episode': episode?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChapterImpl extends Chapter {
  _ChapterImpl({
    _i1.UuidValue? id,
    required double startTime,
    String? title,
    String? img,
    bool? toc,
    double? endTime,
    _i1.UuidValue? episodeId,
    _i2.Episode? episode,
  }) : super._(
         id: id,
         startTime: startTime,
         title: title,
         img: img,
         toc: toc,
         endTime: endTime,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Chapter copyWith({
    _i1.UuidValue? id,
    double? startTime,
    Object? title = _Undefined,
    Object? img = _Undefined,
    bool? toc,
    Object? endTime = _Undefined,
    Object? episodeId = _Undefined,
    Object? episode = _Undefined,
  }) {
    return Chapter(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      title: title is String? ? title : this.title,
      img: img is String? ? img : this.img,
      toc: toc ?? this.toc,
      endTime: endTime is double? ? endTime : this.endTime,
      episodeId: episodeId is _i1.UuidValue? ? episodeId : this.episodeId,
      episode: episode is _i2.Episode? ? episode : this.episode?.copyWith(),
    );
  }
}
