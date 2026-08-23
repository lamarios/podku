import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/components/refresh_indicator/m3e_refresh_indicator.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/bookmarks/states/bookmarks.dart';
import 'package:podku/bookmarks/views/components/bookmark_in_list.dart';
import 'package:podku/utils/views/components/error_listener.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookmarksCubit(BookmarksState()),
      child: ErrorHandler<BookmarksCubit, BookmarksState>(
        child: BlocBuilder<BookmarksCubit, BookmarksState>(
          builder: (context, state) {
            if (state.loading) {
              return Center(child: LoadingIndicator());
            } else {
              return M3ERefreshIndicator.contained(
                onRefresh: () => context.read<BookmarksCubit>().getBookmarks(),
                child: ListView.builder(
                  itemCount: state.bookmarks.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => context.push('/bookmark/${state.bookmarks[index].bookmark!.id}'),
                    child: BookmarkInList(
                      key: ValueKey(state.bookmarks[index].bookmark?.id ?? ''),
                      bookmark: state.bookmarks[index],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
