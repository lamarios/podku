import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:podku_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod/serverpod.dart';

class EpisodesEndpoint extends Endpoint {
  final _progressChannel = '_progressUpdates';

  Future<List<Episode>> getEpisodes(
    Session session, {
    int? after,
    required int pageSize,
  }) async {
    return await Episode.db.find(
      session,
      limit: pageSize,
      orderBy: (p0) => p0.pubDateMillis,
      orderDescending: true,
      where: (p0) =>
          p0.pubDateMillis < (after ?? DateTime.now().millisecondsSinceEpoch),
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

  Future<void> startPlayback(
    Session session,
    Episode episode,
    UuidValue player,
  ) async {
    session.log('Starting playback of episode: ${episode.title}');
    await session.messages.postMessage(
      _progressChannel,
      EpisodeProgress(
        episodeId: episode.id,
        progress: episode.progress,
        player: player,
        newPlayback: true,
      ),
    );
  }

  Future<void> setProgress(
    Session session,
    Episode episode,
    UuidValue player,
  ) async {
    await Episode.db.updateRow(session, episode);
    await session.messages.postMessage(
      _progressChannel,
      EpisodeProgress(
        episodeId: episode.id,
        progress: episode.progress,
        player: player,
        newPlayback: false,
      ),
    );
  }

  Stream<EpisodeProgress> playbackStream(Session session,  UuidValue player) async* {
    session.log('New playback stream subscription from $player');
    final Stream<EpisodeProgress> stream = session.messages.createStream(_progressChannel);

    // we only send updates that are not the user's stuff
    await for (final update in stream.where((u) => u.player != player)) {
      yield update;
    }
  }
}
