import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';

extension HasTranscript on Episode {
  Future<bool> get hasTranscript async => id != null
      ? client.transcripts
            .getEpisodeLanguages(id: id!)
            .then((value) => value.data ?? [])
            .then((value) => value.isNotEmpty)
      : false;
}
