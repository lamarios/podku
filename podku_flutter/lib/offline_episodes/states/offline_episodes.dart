import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:podku/episodes/models/episode_downloads.dart';
import 'package:podku_client/podku_client.dart';

part 'offline_episodes.freezed.dart';

class OfflineEpisodesCubit extends Cubit<OfflineEpisodesState> {
  OfflineEpisodesCubit(super.initialState) {
    getOfflineEpisodes();
  }

  Future<void> getOfflineEpisodes() async {
    final downloads = await getApplicationDocumentsDirectory();

    final episodeDirectory = Directory(
      p.join(downloads.path, EpisodeDownloads.episodeFolder),
    );

    final episodeDirectories = episodeDirectory
        .listSync(recursive: true)
        .map((f) => f.path)
        .where((f) => f.endsWith(EpisodeDownloads.data))
        .map((f) => File(f));

    List<Episode> episodes = [];
    for (final f in episodeDirectories) {
      episodes.add(Episode.fromJson(jsonDecode(await f.readAsString())));
    }

    emit(state.copyWith(offlineEpisodes: episodes));
  }
}

@freezed
sealed class OfflineEpisodesState with _$OfflineEpisodesState {
  const factory OfflineEpisodesState({
    @Default([]) List<Episode> offlineEpisodes,
  }) = _OfflineEpisodesState;
}
