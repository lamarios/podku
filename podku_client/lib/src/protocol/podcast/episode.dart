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

abstract class Episode implements _i1.SerializableModel {
  Episode._({
    _i1.UuidValue? id,
    required this.title,
    this.description,
    this.audioUrl,
    this.audioType,
    this.audioLengthBytes,
    this.pubDateMillis,
    this.durationSeconds,
    this.guid,
    this.imageUrl,
    this.seasonNumber,
    this.episodeNumber,
    this.episodeType,
    required this.explicit,
    this.link,
    required this.podcastId,
    this.podcast,
    double? progress,
  }) : id = id ?? const _i1.Uuid().v4obj(),
       progress = progress ?? 0.0;

  factory Episode({
    _i1.UuidValue? id,
    required String title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    required bool explicit,
    String? link,
    required _i1.UuidValue podcastId,
    _i2.Podcast? podcast,
    double? progress,
  }) = _EpisodeImpl;

  factory Episode.fromJson(Map<String, dynamic> jsonSerialization) {
    return Episode(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      audioUrl: jsonSerialization['audioUrl'] as String?,
      audioType: jsonSerialization['audioType'] as String?,
      audioLengthBytes: jsonSerialization['audioLengthBytes'] as int?,
      pubDateMillis: jsonSerialization['pubDateMillis'] as int?,
      durationSeconds: jsonSerialization['durationSeconds'] as int?,
      guid: jsonSerialization['guid'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      seasonNumber: jsonSerialization['seasonNumber'] as int?,
      episodeNumber: jsonSerialization['episodeNumber'] as int?,
      episodeType: jsonSerialization['episodeType'] as String?,
      explicit: _i1.BoolJsonExtension.fromJson(jsonSerialization['explicit']),
      link: jsonSerialization['link'] as String?,
      podcastId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['podcastId'],
      ),
      podcast: jsonSerialization['podcast'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Podcast>(
              jsonSerialization['podcast'],
            ),
      progress: (jsonSerialization['progress'] as num?)?.toDouble(),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  String title;

  String? description;

  String? audioUrl;

  String? audioType;

  int? audioLengthBytes;

  int? pubDateMillis;

  int? durationSeconds;

  String? guid;

  String? imageUrl;

  int? seasonNumber;

  int? episodeNumber;

  String? episodeType;

  bool explicit;

  String? link;

  _i1.UuidValue podcastId;

  _i2.Podcast? podcast;

  double progress;

  /// Returns a shallow copy of this [Episode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Episode copyWith({
    _i1.UuidValue? id,
    String? title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    bool? explicit,
    String? link,
    _i1.UuidValue? podcastId,
    _i2.Podcast? podcast,
    double? progress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Episode',
      'id': id.toJson(),
      'title': title,
      if (description != null) 'description': description,
      if (audioUrl != null) 'audioUrl': audioUrl,
      if (audioType != null) 'audioType': audioType,
      if (audioLengthBytes != null) 'audioLengthBytes': audioLengthBytes,
      if (pubDateMillis != null) 'pubDateMillis': pubDateMillis,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (guid != null) 'guid': guid,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (seasonNumber != null) 'seasonNumber': seasonNumber,
      if (episodeNumber != null) 'episodeNumber': episodeNumber,
      if (episodeType != null) 'episodeType': episodeType,
      'explicit': explicit,
      if (link != null) 'link': link,
      'podcastId': podcastId.toJson(),
      if (podcast != null) 'podcast': podcast?.toJson(),
      'progress': progress,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EpisodeImpl extends Episode {
  _EpisodeImpl({
    _i1.UuidValue? id,
    required String title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    required bool explicit,
    String? link,
    required _i1.UuidValue podcastId,
    _i2.Podcast? podcast,
    double? progress,
  }) : super._(
         id: id,
         title: title,
         description: description,
         audioUrl: audioUrl,
         audioType: audioType,
         audioLengthBytes: audioLengthBytes,
         pubDateMillis: pubDateMillis,
         durationSeconds: durationSeconds,
         guid: guid,
         imageUrl: imageUrl,
         seasonNumber: seasonNumber,
         episodeNumber: episodeNumber,
         episodeType: episodeType,
         explicit: explicit,
         link: link,
         podcastId: podcastId,
         podcast: podcast,
         progress: progress,
       );

  /// Returns a shallow copy of this [Episode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Episode copyWith({
    _i1.UuidValue? id,
    String? title,
    Object? description = _Undefined,
    Object? audioUrl = _Undefined,
    Object? audioType = _Undefined,
    Object? audioLengthBytes = _Undefined,
    Object? pubDateMillis = _Undefined,
    Object? durationSeconds = _Undefined,
    Object? guid = _Undefined,
    Object? imageUrl = _Undefined,
    Object? seasonNumber = _Undefined,
    Object? episodeNumber = _Undefined,
    Object? episodeType = _Undefined,
    bool? explicit,
    Object? link = _Undefined,
    _i1.UuidValue? podcastId,
    Object? podcast = _Undefined,
    double? progress,
  }) {
    return Episode(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      audioUrl: audioUrl is String? ? audioUrl : this.audioUrl,
      audioType: audioType is String? ? audioType : this.audioType,
      audioLengthBytes: audioLengthBytes is int?
          ? audioLengthBytes
          : this.audioLengthBytes,
      pubDateMillis: pubDateMillis is int? ? pubDateMillis : this.pubDateMillis,
      durationSeconds: durationSeconds is int?
          ? durationSeconds
          : this.durationSeconds,
      guid: guid is String? ? guid : this.guid,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      seasonNumber: seasonNumber is int? ? seasonNumber : this.seasonNumber,
      episodeNumber: episodeNumber is int? ? episodeNumber : this.episodeNumber,
      episodeType: episodeType is String? ? episodeType : this.episodeType,
      explicit: explicit ?? this.explicit,
      link: link is String? ? link : this.link,
      podcastId: podcastId ?? this.podcastId,
      podcast: podcast is _i2.Podcast? ? podcast : this.podcast?.copyWith(),
      progress: progress ?? this.progress,
    );
  }
}
