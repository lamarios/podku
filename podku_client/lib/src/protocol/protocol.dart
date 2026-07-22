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
import 'episodes/episode_progress.dart' as _i2;
import 'podcast/episode.dart' as _i3;
import 'podcast/podcast.dart' as _i4;
import 'podcast/search_result.dart' as _i5;
import 'package:podku_client/src/protocol/podcast/episode.dart' as _i6;
import 'package:podku_client/src/protocol/podcast/podcast.dart' as _i7;
import 'package:podku_client/src/protocol/podcast/search_result.dart' as _i8;
export 'episodes/episode_progress.dart';
export 'podcast/episode.dart';
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

    if (t == _i2.EpisodeProgress) {
      return _i2.EpisodeProgress.fromJson(data) as T;
    }
    if (t == _i3.Episode) {
      return _i3.Episode.fromJson(data) as T;
    }
    if (t == _i4.Podcast) {
      return _i4.Podcast.fromJson(data) as T;
    }
    if (t == _i5.SearchResult) {
      return _i5.SearchResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.EpisodeProgress?>()) {
      return (data != null ? _i2.EpisodeProgress.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Episode?>()) {
      return (data != null ? _i3.Episode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Podcast?>()) {
      return (data != null ? _i4.Podcast.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.SearchResult?>()) {
      return (data != null ? _i5.SearchResult.fromJson(data) : null) as T;
    }
    if (t == List<_i3.Episode>) {
      return (data as List).map((e) => deserialize<_i3.Episode>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i3.Episode>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i3.Episode>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i6.Episode>) {
      return (data as List).map((e) => deserialize<_i6.Episode>(e)).toList()
          as T;
    }
    if (t == List<_i7.Podcast>) {
      return (data as List).map((e) => deserialize<_i7.Podcast>(e)).toList()
          as T;
    }
    if (t == List<_i8.SearchResult>) {
      return (data as List)
              .map((e) => deserialize<_i8.SearchResult>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.EpisodeProgress => 'EpisodeProgress',
      _i3.Episode => 'Episode',
      _i4.Podcast => 'Podcast',
      _i5.SearchResult => 'SearchResult',
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
      case _i2.EpisodeProgress():
        return 'EpisodeProgress';
      case _i3.Episode():
        return 'Episode';
      case _i4.Podcast():
        return 'Podcast';
      case _i5.SearchResult():
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
    if (dataClassName == 'EpisodeProgress') {
      return deserialize<_i2.EpisodeProgress>(data['data']);
    }
    if (dataClassName == 'Episode') {
      return deserialize<_i3.Episode>(data['data']);
    }
    if (dataClassName == 'Podcast') {
      return deserialize<_i4.Podcast>(data['data']);
    }
    if (dataClassName == 'SearchResult') {
      return deserialize<_i5.SearchResult>(data['data']);
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
