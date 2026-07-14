import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:podku_client/podku_client.dart';
import 'package:path/path.dart' as p;

extension EpisodeDownloads on Episode {
  static const String episodeFolder = 'episodes';
 static const String data = 'data.json';
  Future<List<String>> get offlineFiles async {
    final downloads = await getApplicationDocumentsDirectory();

    final episodeDirectory = Directory(
      p.join(downloads.path, episodeFolder, id.uuid),
    );

    if (!(await episodeDirectory.exists())) {
      await episodeDirectory.create(recursive: true);
    }

    return episodeDirectory.listSync().map((f) => f.path).toList();
  }

  String get episodeFile => 'episode.${p.extension(Uri.parse(audioUrl ?? '').path)}';
  String get imageFile => 'image.${p.extension(Uri.parse(podcast?.artworkUrl ?? '').path)}';

  Future<bool> get validOfflineFiles async {
    final files = await offlineFiles;
    final hasData = files.any((element) => element.endsWith(data));
    final hasImage = files.any((element) => element.endsWith(imageFile));
    final hasEpisode = files.any((element) => element.endsWith(episodeFile));

    return hasData && hasEpisode & hasImage;

  }
}
