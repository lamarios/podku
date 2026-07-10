import 'dart:typed_data';

import 'package:podku_server/src/podcast/podcast_parser.dart';
import 'package:podku_server/src/podcast/search/search.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'package:serverpod/server.dart';

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

  Future<Podcast?> getPodcast(Session session, String podcastId) async {
    var podcast = await Podcast.db.findById(session, UuidValue.fromString(podcastId), include: Podcast.include(episodes: Episode.includeList()));
    return podcast;
  }
}
