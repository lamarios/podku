import 'dart:async';

import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/search/model/global_search_result.dart';

class SearchService {
  static const int limit = 5;

  SearchService();

  Future<List<GlobalSearchResult>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final results = await Future.wait(
      [_searchPodcasts(query), _searchEpisodes(query), _searchItunes(query)] as Iterable<Future<dynamic>>,
    );

    // Flatten: podcasts first, then episodes, then transcript snippets
    return <GlobalSearchResult>[...results[0], ...results[1], ...results[2]];
  }

  Future<List<GlobalSearchResult<PodcastLight>>> _searchPodcasts(String query) async {
    final results = await client.podcasts
        .search1(query: query, limit: limit)
        .then((value) => value.data ?? <PodcastLight>[]);

    return results.map((e) => GlobalSearchResult<PodcastLight>(type: .podcast, title: e.name ?? '', data: e)).toList();
  }

  Future<List<GlobalSearchResult<Episode>>> _searchEpisodes(String query) async {
    return client.episodes
        .search2(query: query, limit: limit)
        .then((value) => value.data ?? <Episode>[])
        .then(
          (value) => value
              .map(
                (e) => GlobalSearchResult<Episode>(
                  type: .episode,
                  title: e.title ?? '',
                  subtitle: e.podcast?.name,
                  data: e,
                ),
              )
              .toList(),
        );
  }

  Future<List<GlobalSearchResult<SearchResult>>> _searchItunes(String query) async {
    return client.search
        .search(query: query, limit: limit)
        .then((value) => value.data ?? <SearchResult>[])
        .then(
          (value) =>
              value.map((e) => GlobalSearchResult(type: .discovert, title: e.collectionName ?? '', data: e)).toList(),
        );
  }
}
