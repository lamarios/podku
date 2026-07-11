import 'package:podku_server/src/podcast/podcast_parser.dart';
import 'package:podku_server/src/podcast/search/search.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class PodcastEndpoint extends Endpoint {
  Future<List<Podcast>> getPodcasts(Session session) async {
    return Podcast.db.find(session);
  }

  Future<List<SearchResult>> searchPodcasts(Session session, String query) async {
    return await ItunesPodcastSearch().search(query);
  }

  Future<void> subscribeToPodcast(Session session, SearchResult result) async {
    final alreadySubbed = await Podcast.db
        .find(
          session,
          where: (p) => p.url.equals(result.feedUrl),
        )
        .then((results) => results.isNotEmpty);
    if (result.feedUrl != null && !alreadySubbed) {
      var podcast = Podcast(url: result.feedUrl!, name: result.collectionName ?? result.trackName ?? '', artworkUrl: result.artworkUrl600);

      podcast = await PodcastFeedParser.parseUrl(podcast);

      await Podcast.db.insertRow(session, podcast);
      if (podcast.episodes != null) {
        await Episode.db.insert(session, podcast.episodes!);
      }
    }
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
