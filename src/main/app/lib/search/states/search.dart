import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';

part 'search.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  static const int _limit = 100;
  late final TextEditingController searchController;

  SearchCubit(super.initialState, String? query) {
    searchController = TextEditingController(text: query);
    searchController.addListener(() => search());
    if (query != null) {
      search(force: true);
    }
  }

  @override
  Future<void> close() async {
    searchController.dispose();
    super.close();
  }

  Future<void> search({bool force = false}) async {
    final query = searchController.text;
    if (!force && query == state.query) {
      return;
    }
    EasyDebounce.debounce('search', Duration(milliseconds: 500), () {
      emit(
        state.copyWith(
          loadingDiscover: query.isNotEmpty,
          loadingEpisodes: query.isNotEmpty,
          loadingPodcasts: query.isNotEmpty,
          query: query,
          discoverResults: [],
          podcastResults: [],
          episodeResults: [],
        ),
      );

      if (query.isEmpty) {
        return;
      }

      client.search
          .search(query: query, limit: _limit)
          .then((value) => value.data ?? <SearchResult>[])
          .then((value) => emit(state.copyWith(loadingDiscover: false, discoverResults: value)));

      client.podcasts
          .search1(query: query, limit: _limit)
          .then((value) => value.data ?? <PodcastLight>[])
          .then((value) => emit(state.copyWith(loadingPodcasts: false, podcastResults: value)));
      client.episodes
          .search2(query: query, limit: _limit)
          .then((value) => value.data ?? <EpisodeSearchResult>[])
          .then((value) => emit(state.copyWith(loadingEpisodes: false, episodeResults: value)));
    });
  }
}

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState({
    @Default("") String query,
    @Default(false) bool loadingDiscover,
    @Default(false) bool loadingPodcasts,
    @Default(false) bool loadingEpisodes,
    @Default([]) List<SearchResult> discoverResults,
    @Default([]) List<PodcastLight> podcastResults,
    @Default([]) List<EpisodeSearchResult> episodeResults,
  }) = _SearchState;
}
