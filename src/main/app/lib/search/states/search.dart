import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';

part 'search.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  final TextEditingController searchController = TextEditingController();

  SearchCubit(super.initialState) {
    searchController.addListener(() => search());
  }

  @override
  Future<void> close() async {
    searchController.dispose();
    super.close();
  }

  Future<void> search() async {
    EasyDebounce.debounce('podcast-search', Duration(milliseconds: 500), () async {
      final results = await client.search
          .search(query: searchController.text, limit: 25)
          .then((value) => value.data ?? <SearchResult>[]);
      emit(state.copyWith(results: results));
    });
  }
}

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState({@Default(false) bool loading, @Default([]) List<SearchResult> results}) = _SearchState;
}
