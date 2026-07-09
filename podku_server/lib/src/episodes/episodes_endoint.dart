import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:podku_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';

class EpisodesEndpoint extends Endpoint {
  Future<List<Episode>> getEpisodes(Session session, int? after) async {
    return await Episode.db.find(
      session,
      limit: 100,
      orderBy: (p0) => p0.pubDateMillis,
      orderDescending: true,
      where: (p0) => p0.pubDateMillis < (after ?? DateTime.now().millisecondsSinceEpoch),
      include: Episode.include(podcast: Podcast.include()),
    );
  }

  Future<void> setProgress(Session session, Episode episode) async {
    await Episode.db.updateRow(session, episode);
  }
}
