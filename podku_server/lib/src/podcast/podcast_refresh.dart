import 'package:podku_server/src/generated/episodes/episode_files.dart';
import 'package:podku_server/src/generated/episodes/person.dart';
import 'package:podku_server/src/generated/future_calls.dart';
import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:podku_server/src/generated/podcast/podcast.dart';
import 'package:podku_server/src/podcast/podcast_parser.dart';
import 'package:serverpod/server.dart';

class PodcastRefresh extends FutureCall {
  Future<void> refreshPodcasts(Session session) async {
    try {
      await _refreshPodcasts(session);
    } catch (e, s) {
      session.log('Failed to process podcasts', stackTrace: s, exception: e, level: .error);
    }
    await session.serverpod.futureCalls.callWithDelay(Duration(hours: 1)).podcastRefresh.refreshPodcasts();
  }

  Future<void> _refreshPodcasts(Session session) async {
    final podcasts = await Podcast.db.find(session);

    for (final podcast in podcasts) {
      session.log("Refreshing podcast ${podcast.name} (${podcast.id})");

      final p = await PodcastFeedParser.parseUrl(podcast);
      await Podcast.db.updateRow(session, p);

      for (Episode episode in p.episodes ?? []) {
        await session.db.transaction((transaction) async {
          final dbEpisode = await Episode.db.findFirstRow(
            session,
            where: (p0) => p0.guid.equals(episode.guid ?? '') & p0.podcastId.equals(podcast.id),
            include: Episode.include(files: EpisodeFile.includeList(), people: EpisodePerson.includeList()),
            transaction: transaction,
          );

          if (dbEpisode == null) {
            session.log('Found new episode ${episode.title} (${episode.id}');
            await Episode.db.insertRow(session, episode, transaction: transaction);
            await EpisodeFile.db.insert(
              session,
              (episode.files ?? []).map((e) => e.copyWith(episode: episode, episodeId: episode.id)).toList(),
              transaction: transaction,
            );
            await EpisodePerson.db.insert(
              session,
              (episode.people ?? []).map((e) => e.copyWith(episode: episode, episodeId: episode.id)).toList(),
              transaction: transaction,
            );
          } else {
            await Episode.db.updateRow(
              session,
              episode.copyWith(id: dbEpisode.id, processed: dbEpisode.processed, progress: dbEpisode.progress),
              transaction: transaction,
            );

            bool redoPostProcess = false;
            if ((episode.files ?? []).length != (dbEpisode.files ?? []).length) {
              redoPostProcess = true;
              await EpisodeFile.db.deleteWhere(
                session,
                where: (p0) => p0.episodeId.equals(dbEpisode.id),
                transaction: transaction,
              );
              await EpisodePerson.db.insert(
                session,
                (episode.people ?? []).map((e) => e.copyWith(episode: dbEpisode, episodeId: dbEpisode.id)).toList(),
                transaction: transaction,
              );
            }

            if ((episode.people ?? []).length != (dbEpisode.people ?? []).length) {
              redoPostProcess = true;
              await EpisodePerson.db.deleteWhere(
                session,
                where: (p0) => p0.episodeId.equals(dbEpisode.id),
                transaction: transaction,
              );
              await EpisodePerson.db.insert(
                session,
                (episode.people ?? []).map((e) => e.copyWith(episode: dbEpisode, episodeId: dbEpisode.id)).toList(),
                transaction: transaction,
              );
            }

            if (redoPostProcess) {
              await Episode.db.updateRow(
                session,
                dbEpisode.copyWith(processed: !redoPostProcess),
                transaction: transaction,
              );
            }
          }
        });
      }
    }
  }
}
