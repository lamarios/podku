//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode_person.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EpisodePerson {
  /// Returns a new [EpisodePerson] instance.
  EpisodePerson({

     this.id,

     this.name,

     this.role,

     this.group,

     this.image,

     this.link,

     this.imageEncrypted,
  });

  @JsonKey(
    
    name: r'id',
    required: false,
    includeIfNull: false,
  )


  final String? id;



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
    
    name: r'imageEncrypted',
    required: false,
    includeIfNull: false,
  )


  final String? imageEncrypted;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EpisodePerson &&
      other.id == id &&
      other.name == name &&
      other.role == role &&
      other.group == group &&
      other.image == image &&
      other.link == link &&
      other.imageEncrypted == imageEncrypted;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        role.hashCode +
        group.hashCode +
        image.hashCode +
        link.hashCode +
        imageEncrypted.hashCode;

  factory EpisodePerson.fromJson(Map<String, dynamic> json) => _$EpisodePersonFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodePersonToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

