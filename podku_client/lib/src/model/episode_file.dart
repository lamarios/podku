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

     this.lengthBytes,

     this.bitrate,

     this.height,

     this.title,

     this.codecs,

     this.defaultMedia,

     this.urlEncrypted,
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



  @JsonKey(
    
    name: r'lengthBytes',
    required: false,
    includeIfNull: false,
  )


  final int? lengthBytes;



  @JsonKey(
    
    name: r'bitrate',
    required: false,
    includeIfNull: false,
  )


  final double? bitrate;



  @JsonKey(
    
    name: r'height',
    required: false,
    includeIfNull: false,
  )


  final int? height;



  @JsonKey(
    
    name: r'title',
    required: false,
    includeIfNull: false,
  )


  final String? title;



  @JsonKey(
    
    name: r'codecs',
    required: false,
    includeIfNull: false,
  )


  final String? codecs;



  @JsonKey(
    
    name: r'defaultMedia',
    required: false,
    includeIfNull: false,
  )


  final bool? defaultMedia;



  @JsonKey(
    
    name: r'urlEncrypted',
    required: false,
    includeIfNull: false,
  )


  final String? urlEncrypted;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EpisodeFile &&
      other.id == id &&
      other.url == url &&
      other.type == type &&
      other.mime == mime &&
      other.language == language &&
      other.rel == rel &&
      other.lengthBytes == lengthBytes &&
      other.bitrate == bitrate &&
      other.height == height &&
      other.title == title &&
      other.codecs == codecs &&
      other.defaultMedia == defaultMedia &&
      other.urlEncrypted == urlEncrypted;

    @override
    int get hashCode =>
        id.hashCode +
        url.hashCode +
        type.hashCode +
        mime.hashCode +
        language.hashCode +
        rel.hashCode +
        lengthBytes.hashCode +
        bitrate.hashCode +
        height.hashCode +
        title.hashCode +
        codecs.hashCode +
        defaultMedia.hashCode +
        urlEncrypted.hashCode;

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
chapters(r'chapters'),
@JsonValue(r'audio')
audio(r'audio'),
@JsonValue(r'video')
video(r'video');

const EpisodeFileTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


