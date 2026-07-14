import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku_client/podku_client.dart';

part 'download_manager.freezed.dart';

final _log = Logger('DownloadManagerCubit');

class DownloadManagerCubit extends Cubit<DownloadManagerState> {
  DownloadManagerCubit(super.initialState) {
    getOfflineEpisodes();
  }

  Future<Directory> getEpisodeFolder() async {
    final downloads = await getApplicationDocumentsDirectory();

    final episodeDirectory = Directory(
      p.join(downloads.path, EpisodeDownloads.episodesFolder),
    );

    if (!(await episodeDirectory.exists())) {
      await episodeDirectory.create(recursive: true);
    }

    return downloads;
  }

  Future<void> getOfflineEpisodes() async {
    final episodeDirectories = (await getEpisodeFolder())
        .listSync(recursive: true)
        .map((f) => f.path)
        .where((f) => f.endsWith(EpisodeDownloads.data))
        .map((f) => File(f));

    List<Episode> episodes = [];
    for (final f in episodeDirectories) {
      episodes.add(Episode.fromJson(jsonDecode(await f.readAsString())));
    }

    _log.fine('found ${episodes.length} offline episodes');
    emit(state.copyWith(offlineEpisodes: episodes));
  }

  Future<void> download(Episode e, {required bool manualDownload}) async {
    if (state.downloadStatus.containsKey(e.id.uuid)) {
      return;
    }

    try {
      _log.fine('Downloading episode: ${e.title} (#{${e.id})');
      Map<String, DownloadStatus> statuses = Map.from(state.ongoingDownloads);
      statuses[e.id.uuid] = .downloading;
      emit(state.copyWith(ongoingDownloads: statuses));

      _log.fine('Creating data.json');
      final directory = await e.episodeFolder;

      final File data = File(p.join(directory.path, EpisodeDownloads.data));
      await data.writeAsString(jsonEncode(e.toJson()));

      _log.fine('Downloading audio');

      // downloading the episode
      final File episode = File(p.join(directory.path, e.episodeFile));
      final episodeResponse = await http.get(Uri.parse(e.audioProxyUrl));
      await episode.writeAsBytes(episodeResponse.bodyBytes);

      _log.fine('Downloading image');
      // downloading the image
      if (e.podcast?.artUri != null) {
        final File image = File(p.join(directory.path, e.imageFile));
        final imageResponse = await http.get(e.podcast!.artUri);
        await image.writeAsBytes(imageResponse.bodyBytes);
      }

      statuses = Map.from(state.ongoingDownloads);
      statuses[e.id.uuid] = .downloaded;
      emit(state.copyWith(ongoingDownloads: statuses));

      if (manualDownload) {
        File manualFlag = File(p.join(directory.path, 'manual'));
        await manualFlag.create();
      }

      getOfflineEpisodes();
    } catch (e, s) {
      _log.severe('Failed to download episode', e, s);
    }
  }

  Future<void> delete(Episode e) async {
    final folder = await e.episodeFolder;
    await folder.delete(recursive: true);

    List<Episode> episodes = List.from(state.offlineEpisodes);
    episodes.remove(e);
    emit(state.copyWith(offlineEpisodes: episodes));
  }
}

@freezed
sealed class DownloadManagerState with _$DownloadManagerState {
  const factory DownloadManagerState({
    @Default({}) Map<String, DownloadStatus> ongoingDownloads,
    @Default([]) List<Episode> offlineEpisodes,
  }) = _DownloadManagerState;

  const DownloadManagerState._();

  Map<String, DownloadStatus> get downloadStatus {
    Map<String, DownloadStatus> statuses = Map.from(ongoingDownloads);
    for (final e in offlineEpisodes) {
      statuses[e.id.uuid] = .downloaded;
    }

    return statuses;
  }
}

enum DownloadStatus { noDownload, queuing, downloading, downloaded }
