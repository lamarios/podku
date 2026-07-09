import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../generated/protocol.dart';

/// Thin client for the iTunes Search API, scoped to podcasts.
class ItunesPodcastSearch {
  static const _baseUrl = 'https://itunes.apple.com/search';

  final http.Client _client;

  ItunesPodcastSearch({http.Client? client}) : _client = client ?? http.Client();

  /// Searches the iTunes podcast directory.
  ///
  /// [term] - search string (name, author, etc).
  /// [country] - ISO 2-letter country code, defaults to 'US'.
  /// [limit] - max results, defaults to 25 (Apple's API default is 50).
  Future<List<SearchResult>> search(
      String term, {
        String country = 'US',
        int limit = 25,
      }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'term': term,
      'media': 'podcast',
      'entity': 'podcast',
      'country': country,
      'limit': '$limit',
    });

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw ItunesSearchException(
        'iTunes search failed with status ${response.statusCode}',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final results = (body['results'] as List<dynamic>? ?? []);

    return results
        .map((r) => SearchResult.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Looks up a single podcast by its iTunes collection ID.
  Future<SearchResult?> lookupById(int collectionId) async {
    final uri = Uri.parse('https://itunes.apple.com/lookup').replace(
      queryParameters: {'id': '$collectionId', 'entity': 'podcast'},
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw ItunesSearchException(
        'iTunes lookup failed with status ${response.statusCode}',
      );
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    final results = (body['results'] as List<dynamic>? ?? []);
    if (results.isEmpty) return null;

    return SearchResult.fromJson(results.first as Map<String, dynamic>);
  }

  void dispose() => _client.close();
}

class ItunesSearchException implements Exception {
  final String message;
  ItunesSearchException(this.message);

  @override
  String toString() => 'ItunesSearchException: $message';
}