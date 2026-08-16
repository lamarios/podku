//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/podcast_person.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'podcast_light.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PodcastLight {
  /// Returns a new [PodcastLight] instance.
  PodcastLight({

     this.id,

     this.url,

     this.name,

     this.artworkUrl,

     this.description,

     this.author,

     this.link,

     this.color,

     this.people,

     this.artworkEncrypted,
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
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'artworkUrl',
    required: false,
    includeIfNull: false,
  )


  final String? artworkUrl;



  @JsonKey(
    
    name: r'description',
    required: false,
    includeIfNull: false,
  )


  final String? description;



  @JsonKey(
    
    name: r'author',
    required: false,
    includeIfNull: false,
  )


  final String? author;



  @JsonKey(
    
    name: r'link',
    required: false,
    includeIfNull: false,
  )


  final String? link;



  @JsonKey(
    
    name: r'color',
    required: false,
    includeIfNull: false,
  )


  final String? color;



  @JsonKey(
    
    name: r'people',
    required: false,
    includeIfNull: false,
  )


  final List<PodcastPerson>? people;



  @JsonKey(
    
    name: r'artworkEncrypted',
    required: false,
    includeIfNull: false,
  )


  final String? artworkEncrypted;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PodcastLight &&
      other.id == id &&
      other.url == url &&
      other.name == name &&
      other.artworkUrl == artworkUrl &&
      other.description == description &&
      other.author == author &&
      other.link == link &&
      other.color == color &&
      other.people == people &&
      other.artworkEncrypted == artworkEncrypted;

    @override
    int get hashCode =>
        id.hashCode +
        url.hashCode +
        name.hashCode +
        artworkUrl.hashCode +
        description.hashCode +
        author.hashCode +
        link.hashCode +
        color.hashCode +
        people.hashCode +
        artworkEncrypted.hashCode;

  factory PodcastLight.fromJson(Map<String, dynamic> json) => _$PodcastLightFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastLightToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

