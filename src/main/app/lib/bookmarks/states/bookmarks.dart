import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/utils/models/with_error.dart';

part 'bookmarks.freezed.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit(super.initialState) {
    getBookmarks();
  }

  Future<void> getBookmarks() async {
    try {
      emit(state.copyWith(loading: true));
      final bookmarks = await client.bookmarks.callGet().then((value) => value.data ?? <BookmarkWithTranscript>[]);
      emit(state.copyWith(bookmarks: bookmarks, loading: false));
    } catch (e, s) {
      emit(state.copyWith(loading: false, error: e, stackTrace: s));
    }
  }
}

@freezed
sealed class BookmarksState with _$BookmarksState implements WithError {
  @Implements<WithError>()
  const factory BookmarksState({
    @Default([]) List<BookmarkWithTranscript> bookmarks,
    @Default(true) bool loading,
    dynamic error,
    StackTrace? stackTrace,
  }) = _BookmarksState;
}
