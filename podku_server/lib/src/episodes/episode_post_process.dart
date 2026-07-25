import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:podku_server/src/generated/episodes/chapter.dart';
import 'package:podku_server/src/generated/episodes/chapters.dart';
import 'package:podku_server/src/generated/episodes/episode_files.dart';
import 'package:podku_server/src/generated/episodes/episode_transcript.dart';
import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:podku_server/src/generated/podcast/podcast.dart';
import 'package:podku_server/src/utils/srt_parser.dart';
import 'package:podku_server/src/utils/webvtt_parser.dart';
import 'package:serverpod/server.dart';

class EpisodePostProcess extends FutureCall {
  Future<void> processEpisodesCron(Session session) async {
    try {
      await processEpisodes(session);
    } catch (e, s) {
      session.log('Failed to process episodes', stackTrace: s, exception: e, level: .error);
    }
  }

  Future<void> processPodcast(Session session, Podcast podcast) async {
    for (final e in (podcast.episodes ?? []).where((element) => !element.processed)) {
      session.log('Processing episode ${e.title} (${e.id}');
      await _processEpisode(session, e);
    }
  }

  Future<void> processEpisodes(Session session) async {
    final episodes = await Episode.db.find(
      session,
      where: (p0) => p0.processed.equals(false),
      include: Episode.include(files: EpisodeFile.includeList()),
    );
    for (final e in episodes) {
      session.log('Processing episode ${e.title} (${e.id}');
      await _processEpisode(session, e);
    }
  }

  Future<void> _processEpisode(Session session, Episode episode) async {
    if (episode.files == null) {
      return;
    }

    final chapterProcess = await session.db.transaction((transaction) async {
      // getting chapters

      // we clear the table first
      await Chapter.db.deleteWhere(session, where: (p0) => p0.episodeId.equals(episode.id), transaction: transaction);

      for (final f in episode.files!.where((f) => f.type == .chapters)) {
        final chapters = await _getChapters(f);
        final chapterList = chapters.chapters.map((c) => c.copyWith(episode: episode, episodeId: episode.id)).toList();

        await Chapter.db.insert(session, chapterList);
        session.log('inserted ${chapterList.length} chapters for episode ${episode.id}');
      }

      return true;
    });

    final transcriptProcess = await session.db.transaction((transaction) async {
      await EpisodeTranscript.db.deleteWhere(
        session,
        where: (p0) => p0.episodeId.equals(episode.id),
        transaction: transaction,
      );

      List<EpisodeFile> files = List.from(episode.files!.where((f) => f.type == .transcript));

      // we prioritize text/vtt since we can get the speaker
      files.sort((a, b) {
        if (a.mime == b.mime) return 0;
        if (a.mime == 'text/vtt') return -1;
        if (b.mime == 'text/vtt') return 1;
        return 0;
      });
      for (final f in files) {
        final response = await http.get(Uri.parse(f.url));

        final existing = await EpisodeTranscript.db.findFirstRow(
          session,
          where: (p0) => p0.episodeId.equals(episode.id) & p0.language.equals(f.language),
          transaction: transaction,
        );

        if (existing != null) {
          continue;
        }
        List<EpisodeTranscript> transcript = [];
        if (f.mime == 'text/vtt') {
          transcript.addAll(VttParser().parse(response.body, episode: episode, language: f.language));
        } else if (f.mime == 'application/x-subrip') {
          transcript.addAll(SrtParser().parse(response.body, episode: episode, language: f.language));
        }

        await EpisodeTranscript.db.insert(session, transcript, transaction: transaction);

        session.log('inserted ${transcript.length} transcript lines for episode ${episode.id}');
      }

      return true;
    });

    await Episode.db.updateRow(session, episode.copyWith(processed: transcriptProcess && chapterProcess));
  }

  Future<ChaptersJson> _getChapters(EpisodeFile f) async {
    final response = await http.get(Uri.parse(f.url));

    return ChaptersJson.fromJson(jsonDecode(response.body));
  }
}
