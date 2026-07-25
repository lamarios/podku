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
import '../episodes/chapter.dart' as _i3;
import '../episodes/person.dart' as _i4;
import '../episodes/episode_files.dart' as _i5;
import '../episodes/episode_transcript.dart' as _i6;
import 'package:podku_client/src/protocol/protocol.dart' as _i7;

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
    this.chapters,
    this.people,
    this.files,
    this.transcript,
    bool? processed,
  }) : id = id ?? const _i1.Uuid().v4obj(),
       progress = progress ?? 0.0,
       processed = processed ?? false;

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
    List<_i3.Chapter>? chapters,
    List<_i4.EpisodePerson>? people,
    List<_i5.EpisodeFile>? files,
    List<_i6.EpisodeTranscript>? transcript,
    bool? processed,
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
          : _i7.Protocol().deserialize<_i2.Podcast>(
              jsonSerialization['podcast'],
            ),
      progress: (jsonSerialization['progress'] as num?)?.toDouble(),
      chapters: jsonSerialization['chapters'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i3.Chapter>>(
              jsonSerialization['chapters'],
            ),
      people: jsonSerialization['people'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i4.EpisodePerson>>(
              jsonSerialization['people'],
            ),
      files: jsonSerialization['files'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i5.EpisodeFile>>(
              jsonSerialization['files'],
            ),
      transcript: jsonSerialization['transcript'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i6.EpisodeTranscript>>(
              jsonSerialization['transcript'],
            ),
      processed: jsonSerialization['processed'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['processed']),
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

  List<_i3.Chapter>? chapters;

  List<_i4.EpisodePerson>? people;

  List<_i5.EpisodeFile>? files;

  List<_i6.EpisodeTranscript>? transcript;

  bool processed;

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
    List<_i3.Chapter>? chapters,
    List<_i4.EpisodePerson>? people,
    List<_i5.EpisodeFile>? files,
    List<_i6.EpisodeTranscript>? transcript,
    bool? processed,
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
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJson()),
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (files != null) 'files': files?.toJson(valueToJson: (v) => v.toJson()),
      if (transcript != null)
        'transcript': transcript?.toJson(valueToJson: (v) => v.toJson()),
      'processed': processed,
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
    List<_i3.Chapter>? chapters,
    List<_i4.EpisodePerson>? people,
    List<_i5.EpisodeFile>? files,
    List<_i6.EpisodeTranscript>? transcript,
    bool? processed,
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
         chapters: chapters,
         people: people,
         files: files,
         transcript: transcript,
         processed: processed,
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
    Object? chapters = _Undefined,
    Object? people = _Undefined,
    Object? files = _Undefined,
    Object? transcript = _Undefined,
    bool? processed,
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
      chapters: chapters is List<_i3.Chapter>?
          ? chapters
          : this.chapters?.map((e0) => e0.copyWith()).toList(),
      people: people is List<_i4.EpisodePerson>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      files: files is List<_i5.EpisodeFile>?
          ? files
          : this.files?.map((e0) => e0.copyWith()).toList(),
      transcript: transcript is List<_i6.EpisodeTranscript>?
          ? transcript
          : this.transcript?.map((e0) => e0.copyWith()).toList(),
      processed: processed ?? this.processed,
    );
  }
}
