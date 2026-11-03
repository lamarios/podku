import 'dart:io';

import 'package:openapi/openapi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:podku/episodes/models/episode_url.dart';

extension EpisodeDownloads on Episode {
  static const String episodesFolder = 'episodes';
  static const String data = 'data.json';

  Future<Directory> episodeFolder({bool createIfMissing = false}) async {
    final downloads = await getApplicationDocumentsDirectory();

    final episodeDirectory = Directory(p.join(downloads.path, episodesFolder, id));

    if (createIfMissing && !(await episodeDirectory.exists())) {
      await episodeDirectory.create(recursive: true);
    }

    return episodeDirectory.absolute;
  }

  Future<List<String>> get offlineFiles async {
    final f = await episodeFolder(createIfMissing: false);

    if (!(await f.exists())) {
      return [];
    }

    return f.listSync().map((f) => f.path).toList();
  }

  String get episodeFile => 'episode${p.extension(Uri.parse(listeningFile?.url ?? '').path)}';

  String get episodeTempFile => 'tmp_episode${p.extension(Uri.parse(listeningFile?.url ?? '').path)}';

  String get imageFile => 'image${p.extension(Uri.parse(podcast?.artworkUrl ?? '').path)}';

  String get manualDownload => 'manual';

  Future<bool> get validOfflineFiles async {
    final files = await offlineFiles;
    final hasData = files.any((element) => element.endsWith(data));
    final hasImage = files.any((element) => element.endsWith(imageFile));
    final hasEpisode = files.any((element) => element.endsWith(episodeFile));

    return hasData && hasEpisode & hasImage;
  }

  /// Reads an episode from a downloaded [data] file. Episodes downloaded before the media moved to the episode files
  /// only have the legacy audio fields, their audio file is rebuilt from them.
  static Episode fromOfflineJson(Map<String, dynamic> json) {
    final legacyAudioUrl = json['audioUrl'];
    final hasFiles = (json['files'] as List?)?.isNotEmpty ?? false;
    if (legacyAudioUrl is String && !hasFiles) {
      json = {
        ...json,
        'files': [
          EpisodeFile(
            type: EpisodeFileTypeEnum.audio,
            url: legacyAudioUrl,
            urlEncrypted: json['audioUrlEncrypted'] as String?,
            mime: json['audioType'] as String?,
            lengthBytes: json['audioLengthBytes'] as int?,
            defaultMedia: true,
          ).toJson(),
        ],
      };
    }
    return Episode.fromJson(json);
  }

  Future<bool> get isManualDownload async {
    final files = await offlineFiles;

    return files.any((element) => element.endsWith(manualDownload));
  }
}
