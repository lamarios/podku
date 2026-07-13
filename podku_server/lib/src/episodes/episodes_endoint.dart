import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:podku_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod/serverpod.dart';

class EpisodesEndpoint extends Endpoint {
  Future<List<Episode>> getEpisodes(Session session, { int? after, required int pageSize}) async {
    return await Episode.db.find(
      session,
      limit: pageSize,
      orderBy: (p0) => p0.pubDateMillis,
      orderDescending: true,
      where: (p0) => p0.pubDateMillis < (after ?? DateTime.now().millisecondsSinceEpoch),
      include: Episode.include(podcast: Podcast.include()),
    );
  }

  Future<Episode?> getEpisode(Session session, UuidValue id) async {
    return await Episode.db.findById(
      session,
      id,
      include: Episode.include(podcast: Podcast.include()),
    );
  }

  Future<void> setProgress(Session session, Episode episode) async {
    await Episode.db.updateRow(session, episode);
  }
}
