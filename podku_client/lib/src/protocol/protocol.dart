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
import 'episodes/chapter.dart' as _i2;
import 'episodes/chapters.dart' as _i3;
import 'episodes/episode_file_type.dart' as _i4;
import 'episodes/episode_files.dart' as _i5;
import 'episodes/episode_progress.dart' as _i6;
import 'episodes/episode_transcript.dart' as _i7;
import 'episodes/person.dart' as _i8;
import 'podcast/episode.dart' as _i9;
import 'podcast/person.dart' as _i10;
import 'podcast/podcast.dart' as _i11;
import 'podcast/search_result.dart' as _i12;
import 'package:podku_client/src/protocol/podcast/episode.dart' as _i13;
import 'package:podku_client/src/protocol/podcast/podcast.dart' as _i14;
import 'package:podku_client/src/protocol/podcast/search_result.dart' as _i15;
import 'package:podku_client/src/protocol/episodes/episode_transcript.dart'
    as _i16;
export 'episodes/chapter.dart';
export 'episodes/chapters.dart';
export 'episodes/episode_file_type.dart';
export 'episodes/episode_files.dart';
export 'episodes/episode_progress.dart';
export 'episodes/episode_transcript.dart';
export 'episodes/person.dart';
export 'podcast/episode.dart';
export 'podcast/person.dart';
export 'podcast/podcast.dart';
export 'podcast/search_result.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Chapter) {
      return _i2.Chapter.fromJson(data) as T;
    }
    if (t == _i3.ChaptersJson) {
      return _i3.ChaptersJson.fromJson(data) as T;
    }
    if (t == _i4.EpisodeFileType) {
      return _i4.EpisodeFileType.fromJson(data) as T;
    }
    if (t == _i5.EpisodeFile) {
      return _i5.EpisodeFile.fromJson(data) as T;
    }
    if (t == _i6.EpisodeProgress) {
      return _i6.EpisodeProgress.fromJson(data) as T;
    }
    if (t == _i7.EpisodeTranscript) {
      return _i7.EpisodeTranscript.fromJson(data) as T;
    }
    if (t == _i8.EpisodePerson) {
      return _i8.EpisodePerson.fromJson(data) as T;
    }
    if (t == _i9.Episode) {
      return _i9.Episode.fromJson(data) as T;
    }
    if (t == _i10.PodcastPerson) {
      return _i10.PodcastPerson.fromJson(data) as T;
    }
    if (t == _i11.Podcast) {
      return _i11.Podcast.fromJson(data) as T;
    }
    if (t == _i12.SearchResult) {
      return _i12.SearchResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Chapter?>()) {
      return (data != null ? _i2.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ChaptersJson?>()) {
      return (data != null ? _i3.ChaptersJson.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.EpisodeFileType?>()) {
      return (data != null ? _i4.EpisodeFileType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EpisodeFile?>()) {
      return (data != null ? _i5.EpisodeFile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.EpisodeProgress?>()) {
      return (data != null ? _i6.EpisodeProgress.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.EpisodeTranscript?>()) {
      return (data != null ? _i7.EpisodeTranscript.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.EpisodePerson?>()) {
      return (data != null ? _i8.EpisodePerson.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Episode?>()) {
      return (data != null ? _i9.Episode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PodcastPerson?>()) {
      return (data != null ? _i10.PodcastPerson.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Podcast?>()) {
      return (data != null ? _i11.Podcast.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.SearchResult?>()) {
      return (data != null ? _i12.SearchResult.fromJson(data) : null) as T;
    }
    if (t == List<_i2.Chapter>) {
      return (data as List).map((e) => deserialize<_i2.Chapter>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i2.Chapter>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i2.Chapter>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i8.EpisodePerson>) {
      return (data as List)
              .map((e) => deserialize<_i8.EpisodePerson>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.EpisodePerson>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.EpisodePerson>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i5.EpisodeFile>) {
      return (data as List).map((e) => deserialize<_i5.EpisodeFile>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i5.EpisodeFile>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i5.EpisodeFile>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i7.EpisodeTranscript>) {
      return (data as List)
              .map((e) => deserialize<_i7.EpisodeTranscript>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.EpisodeTranscript>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7.EpisodeTranscript>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i9.Episode>) {
      return (data as List).map((e) => deserialize<_i9.Episode>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.Episode>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i9.Episode>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i10.PodcastPerson>) {
      return (data as List)
              .map((e) => deserialize<_i10.PodcastPerson>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i10.PodcastPerson>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i10.PodcastPerson>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i13.Episode>) {
      return (data as List).map((e) => deserialize<_i13.Episode>(e)).toList()
          as T;
    }
    if (t == List<_i14.Podcast>) {
      return (data as List).map((e) => deserialize<_i14.Podcast>(e)).toList()
          as T;
    }
    if (t == List<_i15.SearchResult>) {
      return (data as List)
              .map((e) => deserialize<_i15.SearchResult>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i16.EpisodeTranscript>) {
      return (data as List)
              .map((e) => deserialize<_i16.EpisodeTranscript>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Chapter => 'Chapter',
      _i3.ChaptersJson => 'ChaptersJson',
      _i4.EpisodeFileType => 'EpisodeFileType',
      _i5.EpisodeFile => 'EpisodeFile',
      _i6.EpisodeProgress => 'EpisodeProgress',
      _i7.EpisodeTranscript => 'EpisodeTranscript',
      _i8.EpisodePerson => 'EpisodePerson',
      _i9.Episode => 'Episode',
      _i10.PodcastPerson => 'PodcastPerson',
      _i11.Podcast => 'Podcast',
      _i12.SearchResult => 'SearchResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('podku.', '');
    }

    switch (data) {
      case _i2.Chapter():
        return 'Chapter';
      case _i3.ChaptersJson():
        return 'ChaptersJson';
      case _i4.EpisodeFileType():
        return 'EpisodeFileType';
      case _i5.EpisodeFile():
        return 'EpisodeFile';
      case _i6.EpisodeProgress():
        return 'EpisodeProgress';
      case _i7.EpisodeTranscript():
        return 'EpisodeTranscript';
      case _i8.EpisodePerson():
        return 'EpisodePerson';
      case _i9.Episode():
        return 'Episode';
      case _i10.PodcastPerson():
        return 'PodcastPerson';
      case _i11.Podcast():
        return 'Podcast';
      case _i12.SearchResult():
        return 'SearchResult';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i2.Chapter>(data['data']);
    }
    if (dataClassName == 'ChaptersJson') {
      return deserialize<_i3.ChaptersJson>(data['data']);
    }
    if (dataClassName == 'EpisodeFileType') {
      return deserialize<_i4.EpisodeFileType>(data['data']);
    }
    if (dataClassName == 'EpisodeFile') {
      return deserialize<_i5.EpisodeFile>(data['data']);
    }
    if (dataClassName == 'EpisodeProgress') {
      return deserialize<_i6.EpisodeProgress>(data['data']);
    }
    if (dataClassName == 'EpisodeTranscript') {
      return deserialize<_i7.EpisodeTranscript>(data['data']);
    }
    if (dataClassName == 'EpisodePerson') {
      return deserialize<_i8.EpisodePerson>(data['data']);
    }
    if (dataClassName == 'Episode') {
      return deserialize<_i9.Episode>(data['data']);
    }
    if (dataClassName == 'PodcastPerson') {
      return deserialize<_i10.PodcastPerson>(data['data']);
    }
    if (dataClassName == 'Podcast') {
      return deserialize<_i11.Podcast>(data['data']);
    }
    if (dataClassName == 'SearchResult') {
      return deserialize<_i12.SearchResult>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
