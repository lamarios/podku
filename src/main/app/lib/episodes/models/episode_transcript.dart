import 'package:openapi/openapi.dart';

extension HasTranscript on Episode {
  bool get hasTranscript =>
      (files ?? []).any((f) => f.type == .transcript && (f.mime == 'text/vtt' || f.mime == 'application/x-subrip'));
}
