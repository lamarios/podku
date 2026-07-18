import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_shared/podku_shared.dart';

part 'search_result.freezed.dart';

class SearchResultCubit extends Cubit<SearchResultState> {
  final SearchResult result;
  final PlayerCubit playerCubit;

  SearchResultCubit(super.initialState, {required this.result, required this.playerCubit}) {
    parseResult();
  }

  Future<void> subscribe() async {
    emit(state.copyWith(subscribing: true));
    final podcast = await client.podcast.subscribeToPodcast(result);
    emit(state.copyWith(subscribing: false, subscribed: true, podcast: _formatPodcast(podcast)));
  }

  Future<void> unsubscribe() async {
    if (state.podcast != null && state.subscribed) {
      emit(state.copyWith(subscribing: true));
      await client.podcast.unsubscribe(state.podcast!.copyWith(episodes: []));
      var podcastId = state.podcast?.id;
      var podcast = state.podcast!.copyWith(id: UuidValue.fromString(unsubbedPodcastUuid));
      emit(state.copyWith(subscribing: false, subscribed: false, podcast: _formatPodcast(podcast)));
      if (playerCubit.state.episode?.podcast?.id == podcastId) {
        playerCubit.stop();
      }
    }
  }

  Podcast _formatPodcast(Podcast parsePodcast) {
    return parsePodcast.copyWith(
      episodes: (parsePodcast.episodes ?? [])
          .map((e) => e.copyWith(podcast: parsePodcast.copyWith(episodes: [])))
          .toList(),
    );
  }

  Future<void> parseResult() async {
    emit(state.copyWith(loading: true));

    final isSubscribed = await client.podcast.getPodcasts().then(
      (e) => e.where((p) => p.url == result.feedUrl).firstOrNull,
    );

    var parsePodcast = await client.podcast.parsePodcast(result);
    if (isSubscribed != null) {
      parsePodcast = (await client.podcast.getPodcast(isSubscribed.id.uuid))!;
    }

    emit(state.copyWith(podcast: _formatPodcast(parsePodcast), loading: false, subscribed: isSubscribed != null));
  }
}

@freezed
sealed class SearchResultState with _$SearchResultState {
  const factory SearchResultState({
    @Default(true) bool loading,
    @Default(false) bool subscribed,
    @Default(false) bool subscribing,
    Podcast? podcast,
  }) = _SearchResultState;
}
