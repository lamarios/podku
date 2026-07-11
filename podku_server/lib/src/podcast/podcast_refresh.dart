import 'package:podku_server/src/generated/endpoints.dart';
import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:podku_server/src/generated/podcast/podcast.dart';
import 'package:podku_server/src/podcast/podcast_parser.dart';
import 'package:serverpod/server.dart';

class PodcastRefresh extends FutureCall {
  Future<void> refreshPodcasts(Session session) async {
    await _refreshPodcasts(session);
    await session.serverpod.futureCalls.callWithDelay(Duration(hours: 1)).podcastRefresh.refreshPodcasts();
  }

  Future<void> _refreshPodcasts(Session session) async {
    final podcasts = await Podcast.db.find(session);

    for (final podcast in podcasts) {
      final p = await PodcastFeedParser.parseUrl(podcast);
      await Podcast.db.updateRow(session, p);

      for (Episode episode in p.episodes ?? []) {
        final dbEpisode = await Episode.db.findFirstRow(
          session,
          where: (p0) => p0.guid.equals(episode.guid ?? '') & p0.podcastId.equals(podcast.id),
        );

        if (dbEpisode == null) {
          await Episode.db.insertRow(session, episode);
        }
      }
    }
  }
}
