// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_light.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PodcastLightCWProxy {
  PodcastLight id(String? id);

  PodcastLight url(String? url);

  PodcastLight name(String? name);

  PodcastLight artworkUrl(String? artworkUrl);

  PodcastLight description(String? description);

  PodcastLight author(String? author);

  PodcastLight link(String? link);

  PodcastLight color(String? color);

  PodcastLight people(List<PodcastPerson>? people);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PodcastLight(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PodcastLight(...).copyWith(id: 12, name: "My name")
  /// ````
  PodcastLight call({
    String? id,
    String? url,
    String? name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    String? color,
    List<PodcastPerson>? people,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPodcastLight.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPodcastLight.copyWith.fieldName(...)`
class _$PodcastLightCWProxyImpl implements _$PodcastLightCWProxy {
  const _$PodcastLightCWProxyImpl(this._value);

  final PodcastLight _value;

  @override
  PodcastLight id(String? id) => this(id: id);

  @override
  PodcastLight url(String? url) => this(url: url);

  @override
  PodcastLight name(String? name) => this(name: name);

  @override
  PodcastLight artworkUrl(String? artworkUrl) => this(artworkUrl: artworkUrl);

  @override
  PodcastLight description(String? description) =>
      this(description: description);

  @override
  PodcastLight author(String? author) => this(author: author);

  @override
  PodcastLight link(String? link) => this(link: link);

  @override
  PodcastLight color(String? color) => this(color: color);

  @override
  PodcastLight people(List<PodcastPerson>? people) => this(people: people);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PodcastLight(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PodcastLight(...).copyWith(id: 12, name: "My name")
  /// ````
  PodcastLight call({
    Object? id = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? artworkUrl = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? link = const $CopyWithPlaceholder(),
    Object? color = const $CopyWithPlaceholder(),
    Object? people = const $CopyWithPlaceholder(),
  }) {
    return PodcastLight(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String?,
      artworkUrl: artworkUrl == const $CopyWithPlaceholder()
          ? _value.artworkUrl
          // ignore: cast_nullable_to_non_nullable
          : artworkUrl as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      author: author == const $CopyWithPlaceholder()
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as String?,
      link: link == const $CopyWithPlaceholder()
          ? _value.link
          // ignore: cast_nullable_to_non_nullable
          : link as String?,
      color: color == const $CopyWithPlaceholder()
          ? _value.color
          // ignore: cast_nullable_to_non_nullable
          : color as String?,
      people: people == const $CopyWithPlaceholder()
          ? _value.people
          // ignore: cast_nullable_to_non_nullable
          : people as List<PodcastPerson>?,
    );
  }
}

extension $PodcastLightCopyWith on PodcastLight {
  /// Returns a callable class that can be used as follows: `instanceOfPodcastLight.copyWith(...)` or like so:`instanceOfPodcastLight.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PodcastLightCWProxy get copyWith => _$PodcastLightCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodcastLight _$PodcastLightFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PodcastLight', json, ($checkedConvert) {
      final val = PodcastLight(
        id: $checkedConvert('id', (v) => v as String?),
        url: $checkedConvert('url', (v) => v as String?),
        name: $checkedConvert('name', (v) => v as String?),
        artworkUrl: $checkedConvert('artworkUrl', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
        author: $checkedConvert('author', (v) => v as String?),
        link: $checkedConvert('link', (v) => v as String?),
        color: $checkedConvert('color', (v) => v as String?),
        people: $checkedConvert(
          'people',
          (v) => (v as List<dynamic>?)
              ?.map((e) => PodcastPerson.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PodcastLightToJson(PodcastLight instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'url': ?instance.url,
      'name': ?instance.name,
      'artworkUrl': ?instance.artworkUrl,
      'description': ?instance.description,
      'author': ?instance.author,
      'link': ?instance.link,
      'color': ?instance.color,
      'people': ?instance.people?.map((e) => e.toJson()).toList(),
    };
