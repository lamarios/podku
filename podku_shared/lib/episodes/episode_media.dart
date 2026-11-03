import 'package:openapi/openapi.dart';

extension EpisodeMedia on Episode {
  /// The audio of the episode: the audio file flagged as default (the feed's enclosure), or the first audio file when
  /// none is. Video files are ignored.
  EpisodeFile? get audioFile => _mediaFile((f) => f.type == EpisodeFileTypeEnum.audio);

  /// The video of the episode: the video file flagged as default (the feed's enclosure), or the first video file when
  /// none is. Audio files are ignored.
  EpisodeFile? get videoFile => _mediaFile((f) => f.type == EpisodeFileTypeEnum.video);

  /// The main media of the episode, audio or video: the media file flagged as default (the feed's enclosure), or the
  /// first media file when none is.
  EpisodeFile? get defaultMedia =>
      _mediaFile((f) => f.type == EpisodeFileTypeEnum.audio || f.type == EpisodeFileTypeEnum.video);

  EpisodeFile? _mediaFile(bool Function(EpisodeFile) test) {
    final media = (files ?? const <EpisodeFile>[]).where(test);
    return media.where((f) => f.defaultMedia == true).firstOrNull ?? media.firstOrNull;
  }
}
