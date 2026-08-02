enum SearchResultType { podcast, episode, discovert }

class GlobalSearchResult<T> {
  final SearchResultType type;
  final String title; // display title
  final String? subtitle; // e.g. episode title for a transcript hit, or podcast name
  final bool? subscribed;
  final T data;

  GlobalSearchResult({required this.type, required this.title, this.subtitle, this.subscribed, required this.data});
}
