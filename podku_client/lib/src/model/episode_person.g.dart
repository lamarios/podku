// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_person.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EpisodePersonCWProxy {
  EpisodePerson name(String? name);

  EpisodePerson role(String? role);

  EpisodePerson group(String? group);

  EpisodePerson image(String? image);

  EpisodePerson link(String? link);

  EpisodePerson id(String? id);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodePerson(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodePerson(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodePerson call({
    String? name,
    String? role,
    String? group,
    String? image,
    String? link,
    String? id,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEpisodePerson.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEpisodePerson.copyWith.fieldName(...)`
class _$EpisodePersonCWProxyImpl implements _$EpisodePersonCWProxy {
  const _$EpisodePersonCWProxyImpl(this._value);

  final EpisodePerson _value;

  @override
  EpisodePerson name(String? name) => this(name: name);

  @override
  EpisodePerson role(String? role) => this(role: role);

  @override
  EpisodePerson group(String? group) => this(group: group);

  @override
  EpisodePerson image(String? image) => this(image: image);

  @override
  EpisodePerson link(String? link) => this(link: link);

  @override
  EpisodePerson id(String? id) => this(id: id);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EpisodePerson(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EpisodePerson(...).copyWith(id: 12, name: "My name")
  /// ````
  EpisodePerson call({
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? group = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? link = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
  }) {
    return EpisodePerson(
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
    );
  }
}

extension $EpisodePersonCopyWith on EpisodePerson {
  /// Returns a callable class that can be used as follows: `instanceOfEpisodePerson.copyWith(...)` or like so:`instanceOfEpisodePerson.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EpisodePersonCWProxy get copyWith => _$EpisodePersonCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodePerson _$EpisodePersonFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EpisodePerson', json, ($checkedConvert) {
      final val = EpisodePerson(
        name: $checkedConvert('name', (v) => v as String?),
        role: $checkedConvert('role', (v) => v as String?),
        group: $checkedConvert('group', (v) => v as String?),
        image: $checkedConvert('image', (v) => v as String?),
        link: $checkedConvert('link', (v) => v as String?),
        id: $checkedConvert('id', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$EpisodePersonToJson(EpisodePerson instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'role': ?instance.role,
      'group': ?instance.group,
      'image': ?instance.image,
      'link': ?instance.link,
      'id': ?instance.id,
    };
