import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/components/refresh_indicator/m3e_refresh_indicator.dart';
import 'package:material_3_expressive/foundations/m3e_icons.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/bookmarks/states/bookmarks.dart';
import 'package:podku/bookmarks/views/components/bookmark_in_list.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/error_listener.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => BookmarksCubit(BookmarksState()),
      child: ErrorHandler<BookmarksCubit, BookmarksState>(
        child: BlocBuilder<BookmarksCubit, BookmarksState>(
          builder: (context, state) {
            if (state.loading) {
              return Center(child: LoadingIndicator());
            } else if (state.bookmarks.isEmpty) {
              return Column(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                mainAxisSize: .max,
                spacing: pu2,
                children: [
                  Text(locals.noBookmarks, style: textTheme.titleLarge),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(M3EIcons.bookmark, size: 50, color: colors.primary),
                      Icon(M3EIcons.add, color: colors.primary),
                    ],
                  ),
                  Text(locals.noBookmarksEnd, style: textTheme.titleLarge),
                ],
              );
            } else {
              return M3ERefreshIndicator.contained(
                onRefresh: () => context.read<BookmarksCubit>().getBookmarks(),
                child: ListView.builder(
                  itemCount: state.bookmarks.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => context.push('/bookmark/${state.bookmarks[index].bookmark!.id}').then((value) {
                      if (context.mounted) {
                        context.read<BookmarksCubit>().getBookmarks(showLoading: false);
                      }
                    }),
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
