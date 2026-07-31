//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Chapter {
  /// Returns a new [Chapter] instance.
  Chapter({

     this.id,

     this.startTime,

     this.title,

     this.img,

     this.toc,

     this.endTime,
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


  final double? startTime;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'img',
    required: false,
    includeIfNull: false,
  )


  final String? img;



  @JsonKey(
    
    name: r'toc',
    required: false,
    includeIfNull: false,
  )


  final bool? toc;



  @JsonKey(
    
    name: r'endTime',
    required: false,
    includeIfNull: false,
  )


  final double? endTime;





    @override
    bool operator ==(Object other) => identical(this, other) || other is Chapter &&
      other.id == id &&
      other.startTime == startTime &&
      other.title == title &&
      other.img == img &&
      other.toc == toc &&
      other.endTime == endTime;

    @override
    int get hashCode =>
        id.hashCode +
        startTime.hashCode +
        title.hashCode +
        img.hashCode +
        toc.hashCode +
        endTime.hashCode;

  factory Chapter.fromJson(Map<String, dynamic> json) => _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

