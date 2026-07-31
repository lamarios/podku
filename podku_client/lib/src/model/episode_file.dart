//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode_file.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EpisodeFile {
  /// Returns a new [EpisodeFile] instance.
  EpisodeFile({

     this.id,

     this.url,

     this.type,

     this.mime,

     this.language,

     this.rel,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



  @JsonKey(
    
    name: r'url',
    required: false,
    includeIfNull: false,
  )


  final String? url;



  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final EpisodeFileTypeEnum? type;



  @JsonKey(
    
    name: r'mime',
    required: false,
    includeIfNull: false,
  )


  final String? mime;



  @JsonKey(
    
    name: r'language',
    required: false,
    includeIfNull: false,
  )


  final String? language;



  @JsonKey(
    
    name: r'rel',
    required: false,
    includeIfNull: false,
  )


  final String? rel;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EpisodeFile &&
      other.id == id &&
      other.url == url &&
      other.type == type &&
      other.mime == mime &&
      other.language == language &&
      other.rel == rel;

    @override
    int get hashCode =>
        id.hashCode +
        url.hashCode +
        type.hashCode +
        mime.hashCode +
        language.hashCode +
        rel.hashCode;

  factory EpisodeFile.fromJson(Map<String, dynamic> json) => _$EpisodeFileFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeFileToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}


enum EpisodeFileTypeEnum {
@JsonValue(r'transcript')
transcript(r'transcript'),
@JsonValue(r'chapters')
chapters(r'chapters');

const EpisodeFileTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


