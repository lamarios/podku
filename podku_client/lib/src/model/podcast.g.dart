// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PodcastCWProxy {
  Podcast id(String? id);

  Podcast url(String? url);

  Podcast name(String? name);

  Podcast artworkUrl(String? artworkUrl);

  Podcast description(String? description);

  Podcast author(String? author);

  Podcast link(String? link);

  Podcast episodes(List<Episode>? episodes);

  Podcast people(List<PodcastPerson>? people);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Podcast(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Podcast(...).copyWith(id: 12, name: "My name")
  /// ````
  Podcast call({
    String? id,
    String? url,
    String? name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<Episode>? episodes,
    List<PodcastPerson>? people,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPodcast.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPodcast.copyWith.fieldName(...)`
class _$PodcastCWProxyImpl implements _$PodcastCWProxy {
  const _$PodcastCWProxyImpl(this._value);

  final Podcast _value;

  @override
  Podcast id(String? id) => this(id: id);

  @override
  Podcast url(String? url) => this(url: url);

  @override
  Podcast name(String? name) => this(name: name);

  @override
  Podcast artworkUrl(String? artworkUrl) => this(artworkUrl: artworkUrl);

  @override
  Podcast description(String? description) => this(description: description);

  @override
  Podcast author(String? author) => this(author: author);

  @override
  Podcast link(String? link) => this(link: link);

  @override
  Podcast episodes(List<Episode>? episodes) => this(episodes: episodes);

  @override
  Podcast people(List<PodcastPerson>? people) => this(people: people);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Podcast(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Podcast(...).copyWith(id: 12, name: "My name")
  /// ````
  Podcast call({
    Object? id = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? artworkUrl = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? link = const $CopyWithPlaceholder(),
    Object? episodes = const $CopyWithPlaceholder(),
    Object? people = const $CopyWithPlaceholder(),
  }) {
    return Podcast(
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
      episodes: episodes == const $CopyWithPlaceholder()
          ? _value.episodes
          // ignore: cast_nullable_to_non_nullable
          : episodes as List<Episode>?,
      people: people == const $CopyWithPlaceholder()
          ? _value.people
          // ignore: cast_nullable_to_non_nullable
          : people as List<PodcastPerson>?,
    );
  }
}

extension $PodcastCopyWith on Podcast {
  /// Returns a callable class that can be used as follows: `instanceOfPodcast.copyWith(...)` or like so:`instanceOfPodcast.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PodcastCWProxy get copyWith => _$PodcastCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Podcast _$PodcastFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Podcast', json, ($checkedConvert) {
      final val = Podcast(
        id: $checkedConvert('id', (v) => v as String?),
        url: $checkedConvert('url', (v) => v as String?),
        name: $checkedConvert('name', (v) => v as String?),
        artworkUrl: $checkedConvert('artworkUrl', (v) => v as String?),
        description: $checkedConvert('description', (v) => v as String?),
        author: $checkedConvert('author', (v) => v as String?),
        link: $checkedConvert('link', (v) => v as String?),
        episodes: $checkedConvert(
          'episodes',
          (v) => (v as List<dynamic>?)
              ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        people: $checkedConvert(
          'people',
          (v) => (v as List<dynamic>?)
              ?.map((e) => PodcastPerson.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PodcastToJson(Podcast instance) => <String, dynamic>{
  'id': ?instance.id,
  'url': ?instance.url,
  'name': ?instance.name,
  'artworkUrl': ?instance.artworkUrl,
  'description': ?instance.description,
  'author': ?instance.author,
  'link': ?instance.link,
  'episodes': ?instance.episodes?.map((e) => e.toJson()).toList(),
  'people': ?instance.people?.map((e) => e.toJson()).toList(),
};
