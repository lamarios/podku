//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/bookmark.dart';
import 'package:openapi/src/model/episode_transcript.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark_with_transcript.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookmarkWithTranscript {
  /// Returns a new [BookmarkWithTranscript] instance.
  BookmarkWithTranscript({

     this.bookmark,

     this.transcripts,
  });

  @JsonKey(
    
    name: r'bookmark',
    required: false,
    includeIfNull: false,
  )


  final Bookmark? bookmark;



  @JsonKey(
    
    name: r'transcripts',
    required: false,
    includeIfNull: false,
  )


  final Map<String, List<EpisodeTranscript>>? transcripts;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookmarkWithTranscript &&
      other.bookmark == bookmark &&
      other.transcripts == transcripts;

    @override
    int get hashCode =>
        bookmark.hashCode +
        transcripts.hashCode;

  factory BookmarkWithTranscript.fromJson(Map<String, dynamic> json) => _$BookmarkWithTranscriptFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkWithTranscriptToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

