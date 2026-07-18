import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:podku_client/podku_client.dart';

extension EpisodeDownloads on Episode {
  static const String episodesFolder = 'episodes';
  static const String data = 'data.json';

  Future<Directory> episodeFolder({bool createIfMissing = false}) async {
    final downloads = await getApplicationDocumentsDirectory();

    final episodeDirectory = Directory(p.join(downloads.path, episodesFolder, id.uuid));

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

  String get episodeFile => 'episode${p.extension(Uri.parse(audioUrl ?? '').path)}';

  String get episodeTempFile => 'tmp_episode${p.extension(Uri.parse(audioUrl ?? '').path)}';

  String get imageFile => 'image${p.extension(Uri.parse(podcast?.artworkUrl ?? '').path)}';

  String get manualDownload => 'manual';

  Future<bool> get validOfflineFiles async {
    final files = await offlineFiles;
    final hasData = files.any((element) => element.endsWith(data));
    final hasImage = files.any((element) => element.endsWith(imageFile));
    final hasEpisode = files.any((element) => element.endsWith(episodeFile));

    return hasData && hasEpisode & hasImage;
  }

  Future<bool> get isManualDownload async {
    final files = await offlineFiles;

    return files.any((element) => element.endsWith(manualDownload));
  }
}
