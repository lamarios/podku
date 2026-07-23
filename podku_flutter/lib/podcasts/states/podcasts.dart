import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:podku/main.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_client/podku_client.dart';

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
      emit(state.copyWith(subscriptions: await client.podcast.getPodcasts()));
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s));
    }
  }

  Future<void> subscribe(SearchResult result) async {
    try {
      emit(state.copyWith(subscribingTo: result));
      await client.podcast.subscribeToPodcast(result);
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
}

@freezed
sealed class PodcastState with _$PodcastState implements WithError {
  @Implements<WithError>()
  const factory PodcastState({
    @Default([]) List<Podcast> subscriptions,
    SearchResult? subscribingTo,
    dynamic error,
    StackTrace? stackTrace,
  }) = _PodcastState;
}
