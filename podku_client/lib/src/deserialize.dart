import 'package:openapi/src/model/chapter.dart';
import 'package:openapi/src/model/episode.dart';
import 'package:openapi/src/model/episode_file.dart';
import 'package:openapi/src/model/episode_person.dart';
import 'package:openapi/src/model/episode_transcript.dart';
import 'package:openapi/src/model/offline_progress.dart';
import 'package:openapi/src/model/playback_progress.dart';
import 'package:openapi/src/model/podcast.dart';
import 'package:openapi/src/model/podcast_light.dart';
import 'package:openapi/src/model/podcast_person.dart';
import 'package:openapi/src/model/search_result.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

  ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType, {bool growable= true}) {
      switch (targetType) {
        case 'String':
          return '$value' as ReturnType;
        case 'int':
          return (value is int ? value : int.parse('$value')) as ReturnType;
        case 'bool':
          if (value is bool) {
            return value as ReturnType;
          }
          final valueString = '$value'.toLowerCase();
          return (valueString == 'true' || valueString == '1') as ReturnType;
        case 'double':
          return (value is double ? value : double.parse('$value')) as ReturnType;
        case 'Chapter':
          return Chapter.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Episode':
          return Episode.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EpisodeFile':
          return EpisodeFile.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EpisodePerson':
          return EpisodePerson.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'EpisodeTranscript':
          return EpisodeTranscript.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'OfflineProgress':
          return OfflineProgress.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PlaybackProgress':
          return PlaybackProgress.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'Podcast':
          return Podcast.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PodcastLight':
          return PodcastLight.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'PodcastPerson':
          return PodcastPerson.fromJson(value as Map<String, dynamic>) as ReturnType;
        case 'SearchResult':
          return SearchResult.fromJson(value as Map<String, dynamic>) as ReturnType;
        default:
          RegExpMatch? match;

          if (value is List && (match = _regList.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toList(growable: growable) as ReturnType;
          }
          if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
            targetType = match![1]!; // ignore: parameter_assignments
            return value
              .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
              .toSet() as ReturnType;
          }
          if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
            targetType = match![1]!.trim(); // ignore: parameter_assignments
            return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map((dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
            ) as ReturnType;
          }
          break;
    }
    throw Exception('Cannot deserialize');
  }