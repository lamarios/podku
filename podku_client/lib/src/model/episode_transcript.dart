//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode_transcript.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EpisodeTranscript {
  /// Returns a new [EpisodeTranscript] instance.
  EpisodeTranscript({

     this.id,

     this.startTime,

     this.endTime,

     this.speaker,

     this.content,

     this.language,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'startTime',
    required: false,
    includeIfNull: false,
  )


  final String? startTime;



  @JsonKey(
    
    name: r'endTime',
    required: false,
    includeIfNull: false,
  )


  final String? endTime;



  @JsonKey(
    
    name: r'speaker',
    required: false,
    includeIfNull: false,
  )


  final String? speaker;



  @JsonKey(
    
    name: r'content',
    required: false,
    includeIfNull: false,
  )


  final String? content;



  @JsonKey(
    
    name: r'language',
    required: false,
    includeIfNull: false,
  )


  final String? language;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EpisodeTranscript &&
      other.id == id &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.speaker == speaker &&
      other.content == content &&
      other.language == language;

    @override
    int get hashCode =>
        id.hashCode +
        startTime.hashCode +
        endTime.hashCode +
        speaker.hashCode +
        content.hashCode +
        language.hashCode;

  factory EpisodeTranscript.fromJson(Map<String, dynamic> json) => _$EpisodeTranscriptFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeTranscriptToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

