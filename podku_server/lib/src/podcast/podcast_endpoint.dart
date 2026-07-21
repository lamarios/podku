import 'package:podku_server/src/podcast/podcast_parser.dart';
import 'package:podku_server/src/podcast/search/search.dart';
import 'package:podku_shared/podku_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class PodcastEndpoint extends Endpoint {
  Future<List<Podcast>> getPodcasts(Session session) async {
    return Podcast.db.find(session, orderBy: (p0) => p0.name);
  }

  Future<List<SearchResult>> searchPodcasts(Session session, String query) async {
    return await ItunesPodcastSearch().search(query);
  }

  Future<Podcast> subscribeToPodcast(Session session, SearchResult result) async {
    final alreadySubbed = await Podcast.db.find(session, where: (p) => p.url.equals(result.feedUrl));
    if (result.feedUrl != null && alreadySubbed.isEmpty) {
      var podcast = Podcast(
        url: result.feedUrl!,
        name: result.collectionName ?? result.trackName ?? '',
        artworkUrl: result.artworkUrl600,
      );

      podcast = await PodcastFeedParser.parseUrl(podcast);

      await Podcast.db.insertRow(session, podcast);
      if (podcast.episodes != null) {
        await Episode.db.insert(session, podcast.episodes!);
      }

      return podcast;
    } else {
      return alreadySubbed.first;
    }
  }

  Future<Podcast> parsePodcast(Session session, SearchResult result) async {
    var podcast = Podcast(
      url: result.feedUrl!,
      name: result.collectionName ?? result.trackName ?? '',
      artworkUrl: result.artworkUrl600,
    );
    podcast = await PodcastFeedParser.parseUrl(podcast);

    return podcast.copyWith(id: UuidValue.fromString(unsubbedPodcastUuid));
  }

  Future<bool> unsubscribe(Session session, Podcast podcast) async {
    final dbPodcast = await getPodcast(session, podcast.id.uuid);
    if (dbPodcast != null) {
      await Podcast.db.deleteRow(session, dbPodcast);
      return true;
    }

    return false;
  }

  Future<Podcast?> getPodcast(Session session, String podcastId) async {
    var podcast = await Podcast.db.findById(
      session,
      UuidValue.fromString(podcastId),
      include: Podcast.include(episodes: Episode.includeList(orderBy: (p0) => p0.pubDateMillis, orderDescending: true)),
    );
    return podcast;
  }
}
