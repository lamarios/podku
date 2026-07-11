import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/main.dart';
import 'package:podku_client/podku_client.dart';

part 'podcasts.freezed.dart';

class PodcastsCubit extends Cubit<PodcastState> {
  PodcastsCubit(super.initialState) {
    getPodcasts();
  }

  Future<void> getPodcasts() async {
    emit(state.copyWith(subscriptions: await client.podcast.getPodcasts()));
  }

  Future<void> subscribe(SearchResult result) async {
    emit(state.copyWith(subscribingTo: result));
    await client.podcast.subscribeToPodcast(result);
    emit(state.copyWith(subscribingTo: null));
    getPodcasts();
  }
}

@freezed
sealed class PodcastState with _$PodcastState {
  const factory PodcastState({@Default([]) List<Podcast> subscriptions, SearchResult? subscribingTo}) = _PodcastState;
}
