import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:material_3_expressive/components/search/controllers/m3e_search_controller.dart';

part 'home.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final M3ESearchController searchController;
  HomeCubit(super.initialState, {required this.searchController});

  void setIndex(int index) {
    if (index == state.selectedIndex) return;
    // previousIndex lets the branch container know which branch to animate out
    emit(state.copyWith(selectedIndex: index, previousIndex: state.selectedIndex));
  }

  void setRailExpanded(bool expanded) {
    emit(state.copyWith(railExpanded: expanded));
  }
}

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({@Default(0) int selectedIndex, int? previousIndex, @Default(true) bool railExpanded}) =
      _HomeState;
}
