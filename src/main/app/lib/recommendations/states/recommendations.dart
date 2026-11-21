import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';

part 'recommendations.freezed.dart';

final _log = Logger('RecommendationsCubit');

/// Loads the podcasts recommended for an episode.
class RecommendationsCubit extends Cubit<RecommendationsState> {
  static const int _limit = 8;

  final String episodeId;

  RecommendationsCubit(super.initialState, {required this.episodeId}) {
    load();
  }

  /// Loads the recommendations. The first load of an episode can take several seconds as the server computes them,
  /// later loads are served from its cache (and no longer contain the podcasts subscribed to in the meantime).
  Future<void> load() async {
    emit(state.copyWith(loading: state.recommendations.isEmpty));
    try {
      final recommendations = (await client.recommendations.getEpisodeRecommendations(
        episodeId: episodeId,
        limit: _limit,
      )).data;
      if (!isClosed) {
        emit(state.copyWith(loading: false, recommendations: recommendations ?? []));
      }
    } catch (e) {
      // recommendations are a nice to have (and unavailable offline), the section is just hidden
      _log.warning('could not load recommendations of episode $episodeId', e);
      if (!isClosed) {
        emit(state.copyWith(loading: false));
      }
    }
  }
}

@freezed
sealed class RecommendationsState with _$RecommendationsState {
  const factory RecommendationsState({@Default(true) bool loading, @Default([]) List<SearchResult> recommendations}) =
      _RecommendationsState;
}
