//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/episode.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookmark.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Bookmark {
  /// Returns a new [Bookmark] instance.
  Bookmark({

     this.id,

     this.time,

     this.topic,

     this.episode,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'time',
    required: false,
    includeIfNull: false,
  )


  final int? time;



  @JsonKey(
    
    name: r'topic',
    required: false,
    includeIfNull: false,
  )


  final String? topic;



  @JsonKey(
    
    name: r'episode',
    required: false,
    includeIfNull: false,
  )


  final Episode? episode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Bookmark &&
      other.id == id &&
      other.time == time &&
      other.topic == topic &&
      other.episode == episode;

    @override
    int get hashCode =>
        id.hashCode +
        time.hashCode +
        topic.hashCode +
        episode.hashCode;

  factory Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

