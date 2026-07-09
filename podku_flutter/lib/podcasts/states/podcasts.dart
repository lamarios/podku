import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_flutter/main.dart';

part 'podcasts.freezed.dart';

class PodcastsCubit extends Cubit<PodcastState> {
  PodcastsCubit(super.initialState) {
    getPodcasts();
  }

  Future<void> getPodcasts() async {
    emit(state.copyWith(subscriptions: await client.podcast.getPodcasts()));
  }

  Future<void> subscribe(SearchResult result) async {
    await client.podcast.subscribeToPodcast(result);
    getPodcasts();
  }
}

@freezed
sealed class PodcastState with _$PodcastState {
  const factory PodcastState({@Default([]) List<Podcast> subscriptions}) = _PodcastState;
}
