import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/src/api/platform_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:url_launcher/url_launcher.dart';

part 'podcasts.freezed.dart';

class PodcastsCubit extends Cubit<PodcastState> {
  late final StreamSubscription<InternetConnectionStatus>? connectionSub;

  PodcastsCubit(super.initialState) {
    getPodcasts();
    // we refresh the podcasts whenever we come back online
    connectionSub = getIt.get<ServerCubit>().stream.map((event) => event.status).listen(onConnectionStatusChange);
  }

  @override
  Future<void> close() async {
    connectionSub?.cancel();
    super.close();
  }

  Future<void> getPodcasts() async {
    if (!isOnline) {
      return;
    }
    try {
      print('GETTING PODCASTS');
      emit(state.copyWith(subscriptions: await client.podcasts.getPodcasts().then((value) => value.data ?? [])));
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }

  Future<void> subscribe(SearchResult result) async {
    try {
      emit(state.copyWith(subscribingTo: result));
      await client.podcasts.subscribeToPodcast(searchResult: result);
      emit(state.copyWith(subscribingTo: null));
      getPodcasts();
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }

  void onConnectionStatusChange(InternetConnectionStatus event) {
    if (event == .connected || event == .slow) {
      getPodcasts();
    } else {
      emit(state.copyWith(subscriptions: []));
    }
  }

  Future<void> downloadOpml() async {
    final url = '${client.serverUrl}/api/podcasts/export';

    if (kIsWeb) {
      launchUrl(Uri.parse(url));
    } else {
      final task = DownloadTask(url: url, filename: 'podcasts.opml');
      await FileDownloader().download(task);
      await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads);
    }
  }

  Future<void> uploadOpml(PlatformFile result) async {
    if (result.path != null) {
      final file = await MultipartFile.fromFile(result.path!);
      await client.podcasts.importFeed(file: file).then((value) => value.data ?? []);
      getPodcasts();
    }
  }
}

@freezed
sealed class PodcastState with _$PodcastState implements WithError {
  @Implements<WithError>()
  const factory PodcastState({
    @Default([]) List<PodcastLight> subscriptions,
    SearchResult? subscribingTo,
    dynamic error,
    StackTrace? stackTrace,
  }) = _PodcastState;
}
