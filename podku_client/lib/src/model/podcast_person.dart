//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'podcast_person.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PodcastPerson {
  /// Returns a new [PodcastPerson] instance.
  PodcastPerson({

     this.name,

     this.role,

     this.group,

     this.image,

     this.link,

     this.id,
  });

  @JsonKey(
    
    name: r'name',
    required: false,
    includeIfNull: false,
  )


  final String? name;



  @JsonKey(
    
    name: r'role',
    required: false,
    includeIfNull: false,
  )


  final String? role;



  @JsonKey(
    
    name: r'group',
    required: false,
    includeIfNull: false,
  )


  final String? group;



  @JsonKey(
    
    name: r'image',
    required: false,
    includeIfNull: false,
  )


  final String? image;



  @JsonKey(
    
    name: r'link',
    required: false,
    includeIfNull: false,
  )


  final String? link;



  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PodcastPerson &&
      other.name == name &&
      other.role == role &&
      other.group == group &&
      other.image == image &&
      other.link == link &&
      other.id == id;

    @override
    int get hashCode =>
        name.hashCode +
        role.hashCode +
        group.hashCode +
        image.hashCode +
        link.hashCode +
        id.hashCode;

  factory PodcastPerson.fromJson(Map<String, dynamic> json) => _$PodcastPersonFromJson(json);

  Map<String, dynamic> toJson() => _$PodcastPersonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

