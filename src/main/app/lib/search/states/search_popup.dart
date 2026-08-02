import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:material_3_expressive/components/search/controllers/m3e_search_controller.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';

part 'search_popup.freezed.dart';

class SearchPopupCubit extends Cubit<SearchPopupState> {
  static const int _limit = 10;
  final M3ESearchController searchController;

  SearchPopupCubit(super.initialState, {required this.searchController}) {
    searchController.addListener(onSearchChanged);
  }

  @override
  Future<void> close() {
    searchController.removeListener(onSearchChanged);
    return super.close();
  }

  void onSearchChanged() {
    EasyDebounce.debounce('search', Duration(milliseconds: 500), () {
      emit(state.copyWith(loadingDiscover: true, loadingEpisodes: true, loadingPodcasts: true));
      // searching itunes
      client.search
          .search(query: searchController.text, limit: _limit)
          .then((value) => value.data ?? <SearchResult>[])
          .then((value) => emit(state.copyWith(loadingDiscover: false, discoverResults: value)));

      client.podcasts
          .search1(query: searchController.text, limit: _limit)
          .then((value) => value.data ?? <PodcastLight>[])
          .then((value) => emit(state.copyWith(loadingPodcasts: false, podcastResults: value)));
      client.episodes
          .search2(query: searchController.text, limit: _limit)
          .then((value) => value.data ?? <Episode>[])
          .then((value) => emit(state.copyWith(loadingEpisodes: false, episodeResults: value)));
    });
  }
}

@freezed
sealed class SearchPopupState with _$SearchPopupState {
  const factory SearchPopupState({
    @Default(false) bool loadingDiscover,
    @Default(false) bool loadingPodcasts,
    @Default(false) bool loadingEpisodes,
    @Default([]) List<SearchResult> discoverResults,
    @Default([]) List<PodcastLight> podcastResults,
    @Default([]) List<Episode> episodeResults,
  }) = _SearchPopupState;
}
