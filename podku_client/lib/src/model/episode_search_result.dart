//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/episode.dart';
import 'package:openapi/src/model/episode_transcript.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode_search_result.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EpisodeSearchResult {
  /// Returns a new [EpisodeSearchResult] instance.
  EpisodeSearchResult({

     this.episode,

     this.matchedTranscripts,
  });

  @JsonKey(
    
    name: r'episode',
    required: false,
    includeIfNull: false,
  )


  final Episode? episode;



  @JsonKey(
    
    name: r'matchedTranscripts',
    required: false,
    includeIfNull: false,
  )


  final List<EpisodeTranscript>? matchedTranscripts;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EpisodeSearchResult &&
      other.episode == episode &&
      other.matchedTranscripts == matchedTranscripts;

    @override
    int get hashCode =>
        episode.hashCode +
        matchedTranscripts.hashCode;

  factory EpisodeSearchResult.fromJson(Map<String, dynamic> json) => _$EpisodeSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeSearchResultToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

