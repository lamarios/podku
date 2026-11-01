import 'package:openapi/openapi.dart';

extension EpisodeMedia on Episode {
  /// The audio of the episode: the audio file flagged as default (the feed's enclosure), or the first audio file when
  /// none is. Video files are ignored.
  EpisodeFile? get audioFile {
    final audios = (files ?? const <EpisodeFile>[]).where((f) => f.type == EpisodeFileTypeEnum.audio);
    return audios.where((f) => f.defaultMedia == true).firstOrNull ?? audios.firstOrNull;
  }
}
