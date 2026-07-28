import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:podku/main.dart';
import 'package:podku/utils.dart';
import 'package:podku_client/podku_client.dart';

part 'podcast_from_url.freezed.dart';

final _log = Logger('PodcastFromUrlCubit');

class PodcastFromUrlCubit extends Cubit<PodcastFromUrlState> {
  final TextEditingController controller = TextEditingController();
  final PageController pageController = PageController(initialPage: 0);

  PodcastFromUrlCubit(super.initialState) {
    pageController.addListener(() => setPage(pageController.page ?? 0));
  }

  @override
  Future<void> close() {
    controller.dispose();
    pageController.dispose();
    return super.close();
  }

  Future<void> parsePodcast() async {
    final url = controller.text;
    try {
      emit(state.copyWith(loading: true, podcastError: false));
      final podcast = await client.podcast.parsePodcast(SearchResult(artistName: '', feedUrl: url));
      emit(state.copyWith(podcast: podcast));
      await pageController.animateToPage(1, duration: animationDuration, curve: Curves.easeInOutQuint);
    } catch (e) {
      _log.warning('could not parse podcast from url $url', e);
      emit(state.copyWith(podcastError: true));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void setPage(double value) {
    _log.fine('page changed $value');
    emit(state.copyWith(page: value.toInt()));
  }

  Future<void> back() async {
    emit(state.copyWith(podcast: null));
    await pageController.animateToPage(0, duration: animationDuration, curve: Curves.easeInOutQuint);
  }
}

@freezed
sealed class PodcastFromUrlState with _$PodcastFromUrlState {
  const factory PodcastFromUrlState({
    @Default(false) bool loading,
    Podcast? podcast,
    @Default(0) int page,
    @Default(false) bool podcastError,
  }) = _PodcastFromUrlState;
}
