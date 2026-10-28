import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/utils/models/with_error.dart';

part 'continue_playing.freezed.dart';

class ContinuePlayingCubit extends Cubit<ContinuePlayingState> {
  ContinuePlayingCubit(super.initialState) {
    getEpisodes();
  }

  Future<void> getEpisodes({bool loading = true}) async {
    try {
      emit(state.copyWith(loading: loading));
      final episodes = await client.episodes.getInProgressEpisodes().then((value) => value.data ?? <Episode>[]);

      if (!isClosed) {
        emit(state.copyWith(loading: false, episodes: episodes));
      }
    } catch (e, s) {
      if (!isClosed) {
        emit(state.copyWith(error: e, stackTrace: s, loading: false));
      }
    }
  }
}

@freezed
sealed class ContinuePlayingState with _$ContinuePlayingState implements WithError {
  @Implements<WithError>()
  const factory ContinuePlayingState({
    @Default([]) List<Episode> episodes,
    @Default(true) bool loading,
    dynamic error,
    StackTrace? stackTrace,
  }) = _ContinuePlayingState;
}
