// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_person.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PodcastPersonCWProxy {
  PodcastPerson name(String? name);

  PodcastPerson role(String? role);

  PodcastPerson group(String? group);

  PodcastPerson image(String? image);

  PodcastPerson link(String? link);

  PodcastPerson id(String? id);

  PodcastPerson imageEncrypted(String? imageEncrypted);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PodcastPerson(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PodcastPerson(...).copyWith(id: 12, name: "My name")
  /// ````
  PodcastPerson call({
    String? name,
    String? role,
    String? group,
    String? image,
    String? link,
    String? id,
    String? imageEncrypted,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPodcastPerson.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPodcastPerson.copyWith.fieldName(...)`
class _$PodcastPersonCWProxyImpl implements _$PodcastPersonCWProxy {
  const _$PodcastPersonCWProxyImpl(this._value);

  final PodcastPerson _value;

  @override
  PodcastPerson name(String? name) => this(name: name);

  @override
  PodcastPerson role(String? role) => this(role: role);

  @override
  PodcastPerson group(String? group) => this(group: group);

  @override
  PodcastPerson image(String? image) => this(image: image);

  @override
  PodcastPerson link(String? link) => this(link: link);

  @override
  PodcastPerson id(String? id) => this(id: id);

  @override
  PodcastPerson imageEncrypted(String? imageEncrypted) =>
      this(imageEncrypted: imageEncrypted);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PodcastPerson(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PodcastPerson(...).copyWith(id: 12, name: "My name")
  /// ````
  PodcastPerson call({
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? group = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? link = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? imageEncrypted = const $CopyWithPlaceholder(),
  }) {
    return PodcastPerson(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String?,
      group: group == const $CopyWithPlaceholder()
          ? _value.group
          // ignore: cast_nullable_to_non_nullable
          : group as String?,
      image: image == const $CopyWithPlaceholder()
          ? _value.image
          // ignore: cast_nullable_to_non_nullable
          : image as String?,
      link: link == const $CopyWithPlaceholder()
          ? _value.link
          // ignore: cast_nullable_to_non_nullable
          : link as String?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      imageEncrypted: imageEncrypted == const $CopyWithPlaceholder()
          ? _value.imageEncrypted
          // ignore: cast_nullable_to_non_nullable
          : imageEncrypted as String?,
    );
  }
}

extension $PodcastPersonCopyWith on PodcastPerson {
  /// Returns a callable class that can be used as follows: `instanceOfPodcastPerson.copyWith(...)` or like so:`instanceOfPodcastPerson.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PodcastPersonCWProxy get copyWith => _$PodcastPersonCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodcastPerson _$PodcastPersonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PodcastPerson', json, ($checkedConvert) {
      final val = PodcastPerson(
        name: $checkedConvert('name', (v) => v as String?),
        role: $checkedConvert('role', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        image: $checkedConvert('image', (v) => v as String?),
        link: $checkedConvert('link', (v) => v as String?),
        id: $checkedConvert('id', (v) => v as String?),
        imageEncrypted: $checkedConvert('imageEncrypted', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$PodcastPersonToJson(PodcastPerson instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'role': ?instance.role,
      'group': ?instance.group,
      'image': ?instance.image,
      'link': ?instance.link,
      'id': ?instance.id,
      'imageEncrypted': ?instance.imageEncrypted,
    };
