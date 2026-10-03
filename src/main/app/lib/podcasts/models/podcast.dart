import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String _podcastsFolders = 'podcasts';

Future<Directory> _podcastFolder(String url, {bool createIfMissing = false}) async {
  final downloads = await getApplicationDocumentsDirectory();

  final episodeDirectory = Directory(
    p.join(downloads.path, _podcastsFolders, md5.convert(utf8.encode(url)).toString()),
  );

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

  Future<File> get imageFile async => await _getPodcastImage(url!, podcast: this);
}

extension PodcastLightExtension on PodcastLight {
  String get artUrl => '${getIt.get<ServerCubit>().state.serverUrl}/media/image/$artworkEncrypted';

  Uri get artUri => Uri.parse(artUrl);

  Future<File> get imageFile async => await _getPodcastImage(url!, podcastLight: this);
}
