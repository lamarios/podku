import 'package:flutter/src/gestures/drag_details.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';

part 'scrobbling.freezed.dart';

class ScrobblingCubit extends Cubit<ScrobblingState> {
  ScrobblingCubit(super.initialState);

  void startDragging(PlayerCubit playerCubit, DragStartDetails details, BoxConstraints constraints) {
    print('Scrobbling: drag start: ${details.localPosition.dx}/${constraints.maxWidth}');
    emit(state.copyWith(holdingPosition: details.localPosition.dx.clamp(0, constraints.maxWidth)));
  }

  void dragUpdate(PlayerCubit playerCubit, DragUpdateDetails details, BoxConstraints constraints) {
    print('Scrobbling: drag update: ${details.localPosition.dx}/${constraints.maxWidth}');
    emit(state.copyWith(holdingPosition: details.localPosition.dx.clamp(0, constraints.maxWidth)));
  }

  void dragEnd(PlayerCubit playerCubit, DragEndDetails details, BoxConstraints constraints) {
    print('Scrobbling: drag end ${details.localPosition.dx}/${constraints.maxWidth}');
    scrobbleTo(playerCubit, details.localPosition.dx / constraints.maxWidth);
    emit(state.copyWith(holdingPosition: null));
  }

  void scrobbleTo(PlayerCubit playerCubit, double percentage) {
    final maxProgress = playerCubit.state.duration;
    getIt.get<PodkuAudioHandler>().seek(Duration(seconds: (maxProgress.inSeconds * percentage.clamp(0, 1)).round()));
  }
}

@freezed
sealed class ScrobblingState with _$ScrobblingState {
  const factory ScrobblingState({@Default(false) bool holding, double? holdingPosition}) = _ScrobblingState;
}
