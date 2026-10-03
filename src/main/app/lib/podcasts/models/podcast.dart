import 'dart:io';

import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String _podcastsFolders = 'podcasts';

Future<Directory> _podcastFolder(String id, {bool createIfMissing = false}) async {
  final downloads = await getApplicationDocumentsDirectory();

  final episodeDirectory = Directory(p.join(downloads.path, _podcastsFolders, id));

  if (createIfMissing && !(await episodeDirectory.exists())) {
    await episodeDirectory.create(recursive: true);
  }

  return episodeDirectory.absolute;
}

Future<File> _getPodcastImage(String id, {Podcast? podcast, PodcastLight? podcastLight}) async {
  final folder = await _podcastFolder(id, createIfMissing: true);

  final extension = p.extension(Uri.parse(podcast?.artUrl ?? podcastLight?.artworkUrl ?? '.jpg').path);

  return File(p.join(folder.path, 'image$extension'));
}

extension PodcastExtension on Podcast {
  String get artUrl => '${getIt.get<ServerCubit>().state.serverUrl}/media/image/$artworkEncrypted';

  Uri get artUri => Uri.parse(artUrl);

  PodcastLight get light => PodcastLight.fromJson(toJson());

  Future<File> get imageFile async => await _getPodcastImage(id ?? url!, podcast: this);
}

extension PodcastLightExtension on PodcastLight {
  String get artUrl => '${getIt.get<ServerCubit>().state.serverUrl}/media/image/$artworkEncrypted';

  Uri get artUri => Uri.parse(artUrl);

  Future<File> get imageFile async => await _getPodcastImage(id ?? url!, podcastLight: this);
}
