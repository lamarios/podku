import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:podku_client/podku_client.dart';
import 'package:podku_shared/podku_shared.dart';

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
        final podcast = await client.podcast.getPodcast(podcastId!);
        emit(state.copyWith(podcast: podcast, loading: false));
      } else if (searchResult != null) {
        final isSubscribed = await client.podcast.getPodcasts().then(
          (e) => e.where((p) => p.url == searchResult!.feedUrl).firstOrNull,
        );

        var parsePodcast = await client.podcast.parsePodcast(searchResult!);
        if (isSubscribed != null) {
          parsePodcast = (await client.podcast.getPodcast(isSubscribed.id.uuid))!;
        }

        emit(state.copyWith(podcast: _formatPodcast(parsePodcast), loading: false));
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

      final podcast = await client.podcast.subscribeToPodcast(subbedResult);
      emit(state.copyWith(subscribing: false, podcast: _formatPodcast(podcast)));
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, subscribing: false));
    }
  }

  Future<void> unsubscribe() async {
    try {
      if (state.podcast != null && state.subscribed) {
        emit(state.copyWith(subscribing: true));
        await client.podcast.unsubscribe(state.podcast!.copyWith(episodes: []));
        var podcastId = state.podcast?.id;
        var podcast = state.podcast!.copyWith(id: UuidValue.fromString(unsubbedPodcastUuid));
        emit(state.copyWith(subscribing: false, podcast: _formatPodcast(podcast)));
        if (playerCubit.state.episode?.podcast?.id == podcastId) {
          playerCubit.stop();
        }
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, subscribing: false));
    }
  }

  Podcast _formatPodcast(Podcast parsePodcast) {
    return parsePodcast.copyWith(
      episodes: (parsePodcast.episodes ?? [])
          .map((e) => e.copyWith(podcast: parsePodcast.copyWith(episodes: [])))
          .toList(),
    );
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

  bool get subscribed => podcast?.id != null && podcast?.id.uuid != unsubbedPodcastUuid;
}
