import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku/episodes/models/episode_url.dart';
import 'package:podku/main.dart';
import 'package:podku/offline_episodes/models/download_progress.dart';
import 'package:podku/offline_episodes/states/download_settings.dart';
import 'package:podku/podcasts/models/podcast.dart';
import 'package:podku/router.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

part 'download_manager.freezed.dart';

final _log = Logger('DownloadManagerCubit');

class DownloadManagerCubit extends Cubit<DownloadManagerState> with WidgetsBindingObserver {
  DownloadManagerCubit(super.initialState) {
    setupDownloads();
  }

  Future<void> setupDownloads() async {
    if (!kIsWeb) {
      final result = await FileDownloader().configure(globalConfig: [(Config.holdingQueue, (1, 1, 1))]);

      _log.fine('Download setup results: $result');

      WidgetsBinding.instance.addObserver(this);
      getOfflineEpisodes();
      initDownloadListener();
      // The app may already be resumed by the time we register the observer,
      // or lifecycleState may not have been set yet — in either case,
      // trigger downloads on the first frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        startAutomaticDownloads();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.resumed) {
      startAutomaticDownloads();
    }
  }

  Future<void> startAutomaticDownloads() async {
    final serverCubit = getIt.get<ServerCubit>();
    if ((await serverCubit.waitForClientToBeSet()) == null) {
      _log.fine('[Automatic] could not get a client');
      return;
    }

    final shouldDownload = await DownloadSettingsCubit.downloadAutomatically;
    if (!shouldDownload) {
      _log.fine('[Automatic] user do not want to download episodes');
      return;
    }
    _log.fine('[Automatic] Starting to download episodes');
    final int episodesToDownload = await DownloadSettingsCubit.podcastEpisodes;
    final podcasts = await client.podcast.getPodcasts();
    for (final p in podcasts) {
      final podcast = await client.podcast.getPodcast(p.id.uuid);
      if (podcast?.episodes?.isEmpty ?? true) {
        continue;
      }
      // we get the first x episodes and downloads them if not already done
      var downloadableEpisodes = podcast!.episodes!.take(episodesToDownload);
      for (final e in downloadableEpisodes) {
        final completeEpisode = e.copyWith(podcast: p);

        if (!await completeEpisode.validOfflineFiles) {
          _log.fine('[Automatic] downloading ${completeEpisode.title}');
          download(completeEpisode, manualDownload: false);
        } else {
          _log.fine('[Automatic] ${completeEpisode.title} already exists');
        }
      }

      // we get the episodes after x and delete if they exist
      var episodesToClean = podcast.episodes!.skip(episodesToDownload);
      for (final e in episodesToClean) {
        final completeEpisode = e.copyWith(podcast: p);
        if ((await completeEpisode.validOfflineFiles) && !(await completeEpisode.isManualDownload)) {
          _log.fine('[Automatic] deleting local copy of ${completeEpisode.title}');
          await delete(completeEpisode);
        }
      }
      getOfflineEpisodes();
    }
  }

  Future<void> initDownloadListener() async {
    FileDownloader().updates.listen(updateDownloadStatus);

    FileDownloader().configureNotification(
      running: TaskNotification('Downloading {displayName}', ''),
      progressBar: true,
    );

    final permissionType = PermissionType.notifications;
    var status = await FileDownloader().permissions.status(permissionType);
    if (status != PermissionStatus.granted) {
      if (await FileDownloader().permissions.shouldShowRationale(permissionType)) {
        final context = navigatorKey.currentContext;
        _log.fine('has context for rationale: ${context != null}');
        if (context != null) {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Enable notifications'),
              content: const Text('We need this to show podcast download progress'),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
            ),
          );
        }
        // hello
      }
      status = await FileDownloader().permissions.request(permissionType);
      debugPrint('Permission for $permissionType was $status');
    }

    // FileDownloader().start();
  }

  Future<Directory> getEpisodeFolder() async {
    final downloads = await getApplicationDocumentsDirectory();

    final episodeDirectory = Directory(p.join(downloads.path, EpisodeDownloads.episodesFolder));

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
      try {
        var episode = Episode.fromJson(jsonDecode(await f.readAsString()));
        if (await episode.validOfflineFiles) {
          episodes.add(episode);
        }
      } catch (e, s) {
        _log.severe('failed to parse offline podcast', e, s);
      }
    }

    _log.fine('found ${episodes.length} offline episodes');
    episodes.sort((a, b) => b.pubDateMillis?.compareTo(a.pubDateMillis ?? 0) ?? 0);
    emit(state.copyWith(offlineEpisodes: episodes));
  }

  Future<void> updateDownloadStatus(TaskUpdate update) async {
    _log.fine('Download update: $update');
    Map<String, DownloadProgress> tasks = Map.from(state.ongoingDownloads);
    var taskEntry = tasks.entries.where((v) => v.value.id == update.task.taskId).firstOrNull;
    var task = taskEntry?.value;

    if (taskEntry != null && task != null) {
      switch (update) {
        case TaskStatusUpdate():
          task = task.copyWith(status: update.status);

          switch (update.status) {
            case .complete:
              getOfflineEpisodes();
              break;
            case .failed:
              tasks.remove(taskEntry.key);
              await FileDownloader().cancel(update.task);
              Future.delayed(Duration(seconds: 5), () async {
                _log.fine('retrying downloading episode: ${taskEntry.key}, download task id ${task?.id}');
                download(
                  (await client.episodes.getEpisode(UuidValue.fromString(taskEntry.key)))!,
                  manualDownload: false,
                  retries: task!.retries + 1,
                );
              });
              break;
            default:
              break;
          }

          break;

        case TaskProgressUpdate():
          task = task.copyWith(progress: update.progress);
          break;
      }
      tasks[taskEntry.key] = task;
      emit(state.copyWith(ongoingDownloads: tasks));
    }

    // Map<String, DownloadProgress> progresses = map
  }

  Future<void> download(Episode e, {required bool manualDownload, int retries = 0}) async {
    if (state.downloadStatus.containsKey(e.id.uuid)) {
      _log.fine("Download already queues: ${state.downloadStatus[e.id.uuid]?.status}");
      return;
    }

    if (retries > 2) {
      _log.fine('Too many retries to download episode ${e.id.uuid}, giving up...');
      return;
    }

    try {
      final downloadTaskId = Uuid().v4();
      _log.fine('Downloading episode: ${e.title} (#{${e.id})');
      Map<String, DownloadProgress> statuses = Map.from(state.ongoingDownloads);
      statuses[e.id.uuid] = DownloadProgress(id: downloadTaskId, status: .enqueued, progress: 0, retries: retries);
      emit(state.copyWith(ongoingDownloads: statuses));

      _log.fine('Creating data.json');
      final directory = await e.episodeFolder(createIfMissing: true);

      final File data = File(p.join(directory.path, EpisodeDownloads.data));
      await data.writeAsString(jsonEncode(e.toJson()));

      _log.fine('Downloading image');
      // downloading the image
      if (e.podcast?.artUri != null) {
        final File image = File(p.join(directory.path, e.imageFile));
        final imageResponse = await http.get(e.podcast!.artUri);
        await image.writeAsBytes(imageResponse.bodyBytes);
      }

      _log.fine('Downloading audio');

      // downloading the episode
      /*
      final File episode = File(p.join(directory.path, e.episodeFile));
      final episodeResponse = await http.get(Uri.parse(e.audioProxyUrl));
      await episode.writeAsBytes(episodeResponse.bodyBytes);
*/
      final task = DownloadTask(
        taskId: downloadTaskId,
        url: e.audioProxyUrl,
        baseDirectory: BaseDirectory.applicationDocuments,
        directory: '${EpisodeDownloads.episodesFolder}/${e.id.uuid}',
        filename: e.episodeFile,
        updates: .statusAndProgress,
        displayName: e.title,
      );

      await FileDownloader().enqueue(task);

      if (manualDownload) {
        File manualFlag = File(p.join(directory.path, e.manualDownload));
        await manualFlag.create();
      }

      getOfflineEpisodes();
    } catch (e, s) {
      _log.severe('Failed to download episode', e, s);
    }
  }

  Future<void> delete(Episode e) async {
    final folder = await e.episodeFolder(createIfMissing: true);
    await folder.delete(recursive: true);
    Map<String, DownloadProgress> statuses = Map.from(state.ongoingDownloads);
    statuses.remove(e.id.uuid);

    List<Episode> episodes = List.from(state.offlineEpisodes);
    episodes.remove(e);
    emit(state.copyWith(offlineEpisodes: episodes, ongoingDownloads: statuses));
  }
}

@freezed
sealed class DownloadManagerState with _$DownloadManagerState {
  const factory DownloadManagerState({
    @Default({}) Map<String, DownloadProgress> ongoingDownloads,
    @Default([]) List<Episode> offlineEpisodes,
  }) = _DownloadManagerState;

  const DownloadManagerState._();

  Map<String, DownloadProgress> get downloadStatus {
    Map<String, DownloadProgress> statuses = Map.from(ongoingDownloads);
    for (final e in offlineEpisodes) {
      statuses[e.id.uuid] = DownloadProgress(id: '', status: .complete, progress: 100);
    }

    return statuses;
  }
}

enum DownloadStatus { noDownload, queuing, downloading, downloaded }
