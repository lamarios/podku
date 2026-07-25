import 'package:podku_server/src/generated/episodes/episode_transcript.dart';
import 'package:podku_server/src/generated/podcast/episode.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/server.dart';

class TranscriptEndpoint extends Endpoint {
  Future<List<String>> getLanguages(Session session, Episode episode) async {
    final result = await session.db.unsafeQuery(
      r'SELECT DISTINCT language FROM episode_transcripts WHERE episode_transcripts."episodeId" = @episodeId',
      parameters: QueryParameters.named({'episodeId': episode.id.uuid}),
    );

    return result.map((row) => row.toColumnMap()).map((e) => e['language'] as String).toList();
  }

  Future<List<EpisodeTranscript>> getTranscript(Session session, Episode episode, String? language) async {
    return await EpisodeTranscript.db.find(
      session,
      where: (p0) => p0.language.equals(language) & p0.episodeId.equals(episode.id),
    );
  }
}
