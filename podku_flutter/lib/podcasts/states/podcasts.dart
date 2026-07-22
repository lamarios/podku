import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/main.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_client/podku_client.dart';

part 'podcasts.freezed.dart';

class PodcastsCubit extends Cubit<PodcastState> {
  PodcastsCubit(super.initialState) {
    getPodcasts();
  }

  Future<void> getPodcasts() async {
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
