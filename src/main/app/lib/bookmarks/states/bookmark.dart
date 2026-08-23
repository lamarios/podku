import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/transcript.dart';
import 'package:podku/utils/models/with_error.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

part 'bookmark.freezed.dart';

final _log = Logger('BookmarkCubit');

class BookmarkCubit extends Cubit<BookmarkState> {
  final ScrollController scrollController = ScrollController();
  late final ListObserverController observerController;
  final String bookmarkId;

  BookmarkCubit(super.initialState, {required this.bookmarkId}) {
    observerController = ListObserverController(controller: scrollController);
    getBookmark();
  }

  Future<void> getBookmark() async {
    try {
      var bookmark = await client.bookmarks.get1(id: bookmarkId).then((value) => value.data);

      var defaultLanguage = bookmark?.transcripts?.keys.firstOrNull;

      emit(state.copyWith(bookmark: bookmark, selectedLanguage: defaultLanguage, loading: false));

      if (defaultLanguage != null) {
        _log.fine('Default language: $defaultLanguage');
        var index = TranscriptCubit.findCurrentTranscriptIndex(
          bookmark?.transcripts?[defaultLanguage] ?? [],
          Duration(seconds: bookmark?.bookmark?.time ?? 0),
        );
        emit(state.copyWith(timeIndex: index));
        _log.fine('index: $index');
        if (index != -1) {
          await Future.delayed(Duration(seconds: 1));
          observerController.jumpTo(index: index);
        }
      }
    } catch (e, s) {
      emit(state.copyWith(error: e, stackTrace: s, loading: false));
    }
  }

  void setLanguage(String? language) {
    emit(state.copyWith(selectedLanguage: language));
  }
}

@freezed
sealed class BookmarkState with _$BookmarkState implements WithError {
  @Implements<WithError>()
  const factory BookmarkState({
    BookmarkWithTranscript? bookmark,
    @Default(true) bool loading,
    String? selectedLanguage,
    @Default(-1) int timeIndex,
    dynamic error,
    StackTrace? stackTrace,
  }) = _BookmarkState;
}
