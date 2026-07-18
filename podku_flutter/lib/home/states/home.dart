import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(super.initialState);

  void setIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({@Default(0) int selectedIndex}) = _HomeState;
}
