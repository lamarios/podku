//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/chapter.dart';
import 'package:openapi/src/model/episode_file.dart';
import 'package:openapi/src/model/episode_person.dart';
import 'package:openapi/src/model/podcast_light.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Episode {
  /// Returns a new [Episode] instance.
  Episode({

     this.id,

     this.title,

     this.description,

     this.audioUrl,

     this.audioType,

     this.audioLengthBytes,

     this.pubDateMillis,

     this.durationSeconds,

     this.progress,

     this.guid,

     this.imageUrl,

     this.seasonNumber,

     this.episodeNumber,

     this.episodeType,

     this.explicit,

     this.link,

     this.processed,

     this.chapters,

     this.files,

     this.people,

     this.podcast,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'audioUrl',
    required: false,
    includeIfNull: false,
  )


  final String? audioUrl;



  @JsonKey(
    
    name: r'audioType',
    required: false,
    includeIfNull: false,
  )


  final String? audioType;



  @JsonKey(
    
    name: r'audioLengthBytes',
    required: false,
    includeIfNull: false,
  )


  final int? audioLengthBytes;



  @JsonKey(
    
    name: r'pubDateMillis',
    required: false,
    includeIfNull: false,
  )


  final int? pubDateMillis;



  @JsonKey(
    
    name: r'durationSeconds',
    required: false,
    includeIfNull: false,
  )


  final int? durationSeconds;



  @JsonKey(
    
    name: r'progress',
    required: false,
    includeIfNull: false,
  )


  final double? progress;



  @JsonKey(
    
    name: r'guid',
    required: false,
    includeIfNull: false,
  )


  final String? guid;



  @JsonKey(
    
    name: r'imageUrl',
    required: false,
    includeIfNull: false,
  )


  final String? imageUrl;



  @JsonKey(
    
    name: r'seasonNumber',
    required: false,
    includeIfNull: false,
  )


  final int? seasonNumber;



  @JsonKey(
    
    name: r'episodeNumber',
    required: false,
    includeIfNull: false,
  )


  final int? episodeNumber;



  @JsonKey(
    
    name: r'episodeType',
    required: false,
    includeIfNull: false,
  )


  final String? episodeType;



  @JsonKey(
    
    name: r'explicit',
    required: false,
    includeIfNull: false,
  )


  final bool? explicit;



  @JsonKey(
    
    name: r'link',
    required: false,
    includeIfNull: false,
  )


  final String? link;



  @JsonKey(
    
    name: r'processed',
    required: false,
    includeIfNull: false,
  )


  final bool? processed;



  @JsonKey(
    
    name: r'chapters',
    required: false,
    includeIfNull: false,
  )


  final List<Chapter>? chapters;



  @JsonKey(
    
    name: r'files',
    required: false,
    includeIfNull: false,
  )


  final List<EpisodeFile>? files;



  @JsonKey(
    
    name: r'people',
    required: false,
    includeIfNull: false,
  )


  final List<EpisodePerson>? people;



  @JsonKey(
    
    name: r'podcast',
    required: false,
    includeIfNull: false,
  )


  final PodcastLight? podcast;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Episode &&
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.audioUrl == audioUrl &&
      other.audioType == audioType &&
      other.audioLengthBytes == audioLengthBytes &&
      other.pubDateMillis == pubDateMillis &&
      other.durationSeconds == durationSeconds &&
      other.progress == progress &&
      other.guid == guid &&
      other.imageUrl == imageUrl &&
      other.seasonNumber == seasonNumber &&
      other.episodeNumber == episodeNumber &&
      other.episodeType == episodeType &&
      other.explicit == explicit &&
      other.link == link &&
      other.processed == processed &&
      other.chapters == chapters &&
      other.files == files &&
      other.people == people &&
      other.podcast == podcast;

    @override
    int get hashCode =>
        id.hashCode +
        title.hashCode +
        description.hashCode +
        audioUrl.hashCode +
        audioType.hashCode +
        audioLengthBytes.hashCode +
        pubDateMillis.hashCode +
        durationSeconds.hashCode +
        progress.hashCode +
        guid.hashCode +
        imageUrl.hashCode +
        seasonNumber.hashCode +
        episodeNumber.hashCode +
        episodeType.hashCode +
        explicit.hashCode +
        link.hashCode +
        processed.hashCode +
        chapters.hashCode +
        files.hashCode +
        people.hashCode +
        podcast.hashCode;

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

