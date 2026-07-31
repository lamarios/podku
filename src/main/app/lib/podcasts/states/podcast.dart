import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/with_error.dart';

part 'podcast.freezed.dart';

class PodcastCubit extends Cubit<PodcastState> {
  final String? podcastId;
  final SearchResult? searchResult;
  final PlayerCubit playerCubit;

  PodcastCubit(super.initialState, {this.podcastId, this.searchResult, required this.playerCubit}) {
    getPodcast();
  }

  Future<void> getPodcast() async {
    try {
      if (podcastId != null) {
        final podcast = await client.podcasts.getPodcast(id: podcastId!).then((value) => value.data);
        emit(state.copyWith(podcast: podcast, loading: false));
      } else if (searchResult != null) {
        final isSubscribed = await client.podcasts
            .getPodcasts()
            .then((value) => value.data ?? [])
            .then((e) => e.where((p) => p.url == searchResult!.feedUrl).firstOrNull);

        var parsePodcast = await client.podcasts.parsePodcast(searchResult: searchResult!).then((value) => value.data);
        if (isSubscribed != null) {
          parsePodcast = (await client.podcasts.getPodcast(id: isSubscribed.id.uuid)).data;
        }

        if (parsePodcast != null) {
          emit(state.copyWith(podcast: parsePodcast, loading: false));
        } else {
          emit(state.copyWith(loading: false));
        }
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
    }
  }

  Future<void> subscribe() async {
    try {
      emit(state.copyWith(subscribing: true));

      // here depending on how we opened the state, we might not have a search result
      // and we should have a podcast
      final subbedResult =
          searchResult ?? SearchResult(artistName: state.podcast?.name ?? '', feedUrl: state.podcast?.url);

      final podcast = (await client.podcasts.subscribeToPodcast(searchResult: subbedResult)).data;
      if(podcast != null) {
        emit(state.copyWith(subscribing: false, podcast: podcast));
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, subscribing: false));
    }
  }

  Future<void> unsubscribe() async {
    try {
      if (state.podcast != null && state.subscribed) {
        emit(state.copyWith(subscribing: true));
        await client.podcasts.unsubsribe(id: state.podcast!.id!);
        var podcastId = state.podcast?.id;
        var podcast = state.podcast!.copyWith(id: unsubbedPodcastUuid);
        emit(state.copyWith(subscribing: false, podcast: podcast));
        if (playerCubit.state.episode?.podcast?.id == podcastId) {
          playerCubit.stop();
        }
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, subscribing: false));
    }
  }

}

@freezed
sealed class PodcastState with _$PodcastState implements WithError {
  @Implements<WithError>()
  const factory PodcastState({
    Podcast? podcast,
    @Default(true) bool loading,
    @Default(false) bool subscribing,
    dynamic error,
    StackTrace? stackTrace,
  }) = _PodcastState;

  const PodcastState._();

  bool get subscribed => podcast?.id != null && podcast?.id != unsubbedPodcastUuid;
}
