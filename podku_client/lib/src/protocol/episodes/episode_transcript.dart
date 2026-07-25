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

abstract class EpisodeTranscript implements _i1.SerializableModel {
  EpisodeTranscript._({
    _i1.UuidValue? id,
    required this.startTime,
    required this.endTime,
    this.speaker,
    required this.content,
    this.language,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory EpisodeTranscript({
    _i1.UuidValue? id,
    required String startTime,
    required String endTime,
    String? speaker,
    required String content,
    String? language,
    required _i1.UuidValue episodeId,
    _i2.Episode? episode,
  }) = _EpisodeTranscriptImpl;

  factory EpisodeTranscript.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodeTranscript(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      speaker: jsonSerialization['speaker'] as String?,
      content: jsonSerialization['content'] as String,
      language: jsonSerialization['language'] as String?,
      episodeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['episodeId'],
      ),
      episode: jsonSerialization['episode'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Episode>(
              jsonSerialization['episode'],
            ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  String startTime;

  String endTime;

  String? speaker;

  String content;

  String? language;

  _i1.UuidValue episodeId;

  _i2.Episode? episode;

  /// Returns a shallow copy of this [EpisodeTranscript]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EpisodeTranscript copyWith({
    _i1.UuidValue? id,
    String? startTime,
    String? endTime,
    String? speaker,
    String? content,
    String? language,
    _i1.UuidValue? episodeId,
    _i2.Episode? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EpisodeTranscript',
      'id': id.toJson(),
      'startTime': startTime,
      'endTime': endTime,
      if (speaker != null) 'speaker': speaker,
      'content': content,
      if (language != null) 'language': language,
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

class _EpisodeTranscriptImpl extends EpisodeTranscript {
  _EpisodeTranscriptImpl({
    _i1.UuidValue? id,
    required String startTime,
    required String endTime,
    String? speaker,
    required String content,
    String? language,
    required _i1.UuidValue episodeId,
    _i2.Episode? episode,
  }) : super._(
         id: id,
         startTime: startTime,
         endTime: endTime,
         speaker: speaker,
         content: content,
         language: language,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [EpisodeTranscript]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EpisodeTranscript copyWith({
    _i1.UuidValue? id,
    String? startTime,
    String? endTime,
    Object? speaker = _Undefined,
    String? content,
    Object? language = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return EpisodeTranscript(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      speaker: speaker is String? ? speaker : this.speaker,
      content: content ?? this.content,
      language: language is String? ? language : this.language,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i2.Episode? ? episode : this.episode?.copyWith(),
    );
  }
}
