import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';

part 'continue_playing.freezed.dart';

class ContinuePlayingCubit extends Cubit<ContinuePlayingState> {
  ContinuePlayingCubit(super.initialState) {
    getEpisodes();
  }

  Future<void> getEpisodes() async {
    emit(state.copyWith(loading: true));
    final episodes = await client.episodes.getInProgressEpisodes().then((value) => value.data ?? <Episode>[]);

    if (!isClosed) {
      emit(state.copyWith(loading: false, episodes: episodes));
    }
  }
}

@freezed
sealed class ContinuePlayingState with _$ContinuePlayingState {
  const factory ContinuePlayingState({@Default([]) List<Episode> episodes, @Default(true) bool loading}) =
      _ContinuePlayingState;
}
