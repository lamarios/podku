import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/components/dialogs/m3e_dialogs.dart';
import 'package:material_3_expressive/components/icon_buttons/m3e_icon_buttons.dart';
import 'package:material_3_expressive/components/toggle_button_group/m3e_toggle_button_group.dart';
import 'package:material_3_expressive/components/toggle_button_group/models/m3e_button_group_action.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/bookmarks/states/bookmark.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/duration_utils.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/error_listener.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

const double _imageSize = 150;
final _log = Logger('BookmarkScreen');

class BookmarkScreen extends StatelessWidget {
  final String? bookmarkId;

  const BookmarkScreen({super.key, required this.bookmarkId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;

    return bookmarkId == null
        ? Center(child: Icon(M3EIcons.emoji_emotions_outlined))
        : BlocProvider(
            create: (context) => BookmarkCubit(BookmarkState(), bookmarkId: bookmarkId!),
            child: Scaffold(
              appBar: M3EAppBar.top(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.transparent,
                actions: [
                  Builder(
                    builder: (context) {
                      return M3EIconButton(
                        icon: Icon(M3EIcons.delete),
                        onPressed: () async {
                          final delete = await M3EDialog.show<bool>(
                            context,
                            dialog: Builder(
                              builder: (context) {
                                return M3EDialog(
                                  title: locals.deleteBookmark,
                                  content: Text(locals.cannotBeUndone),
                                  actions: [
                                    M3EButton(
                                      style: .text,
                                      child: Text(locals.cancel),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    M3EButton(
                                      style: .text,
                                      child: Text(locals.ok),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                          _log.fine('Delete bookmark? $delete');
                          if (context.mounted && (delete ?? false)) {
                            await context.read<BookmarkCubit>().delete();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                bottom: false,
                child: ErrorHandler<BookmarkCubit, BookmarkState>(
                  child: BlocBuilder<BookmarkCubit, BookmarkState>(
                    builder: (context, state) {
                      var cubit = context.read<BookmarkCubit>();

                      if (state.loading || state.bookmark == null) {
                        return Center(child: LoadingIndicator());
                      } else {
                        var bookmark = state.bookmark!;
                        var time = Duration(seconds: bookmark.bookmark?.time ?? 0);
                        return Padding(
                          padding: .symmetric(horizontal: pu4),
                          child: Column(
                            spacing: pu2,
                            crossAxisAlignment: .stretch,
                            children: [
                              if (bookmark.bookmark?.episode?.podcast != null)
                                Center(
                                  child: PodcastImage(
                                    podcastLight: bookmark.bookmark?.episode?.podcast,
                                    width: _imageSize,
                                    height: _imageSize,
                                    borderRadius: pu4,
                                  ),
                                ),
                              Text(bookmark.bookmark?.episode?.title ?? '', style: textTheme.titleMedium),
                              if ((bookmark.bookmark?.time ?? 0) > 0)
                                Row(
                                  mainAxisSize: .max,
                                  mainAxisAlignment: .center,
                                  spacing: pu2,
                                  children: [
                                    Icon(M3EIcons.access_time, size: 20, color: colors.primary),
                                    Text(
                                      printDuration(time),
                                      style: textTheme.bodyLarge?.copyWith(color: colors.primary),
                                    ),
                                  ],
                                ),
                              if (bookmark.transcripts?.values.any((element) => element.isNotEmpty) ?? false) ...[
                                M3EButtonGroup(
                                  size: .xs,
                                  style: .tonal,
                                  overflow: .scroll,
                                  onSelectedIndexChanged: (value) {
                                    return cubit.setLanguage(bookmark.transcripts?.keys.elementAt(value ?? 0));
                                  },
                                  selectedIndex: bookmark.transcripts?.keys.toList().indexOf(
                                    state.selectedLanguage ?? '',
                                  ),
                                  actions:
                                      bookmark.transcripts?.keys
                                          .map(
                                            (e) => M3EButtonGroupAction(
                                              icon: e == 'a.i' ? Icon(M3EIcons.auto_awesome) : null,
                                              label: Text(e == 'a.i' ? locals.aiGeneratedTranscript : e),
                                            ),
                                          )
                                          .toList() ??
                                      <M3EButtonGroupAction>[],
                                ),
                                Expanded(
                                  child: ListViewObserver(
                                    controller: cubit.observerController,
                                    child: ListView.builder(
                                      controller: cubit.scrollController,
                                      itemCount: bookmark.transcripts?[state.selectedLanguage]?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        var line = bookmark.transcripts?[state.selectedLanguage]?[index];
                                        return _TranscriptLine(
                                          transcript: line!,
                                          isBookmark: state.timeIndex == index,
                                          episode: bookmark.bookmark!.episode!,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ] else
                                M3EIconButton(
                                  icon: Icon(M3EIcons.play_arrow),
                                  size: .lg,
                                  variant: .tonal,
                                  onPressed: () => context.read<PlayerCubit>().playEpisode(
                                    bookmark.bookmark!.episode!,
                                    initialPosition: Duration(seconds: bookmark.bookmark?.time ?? 0),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          );
  }
}

class _TranscriptLine extends StatelessWidget {
  final Episode episode;
  final EpisodeTranscript transcript;
  final bool isBookmark;

  const _TranscriptLine({required this.transcript, required this.isBookmark, required this.episode});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ConditionalWrap(
      wrapIf: isBookmark,
      wrapper: (child) => Container(
        decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: .circular(pu2)),
        child: child,
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          M3EButton.icon(
            style: .text,
            size: .xs,
            label: Text(transcript.startTime?.split('.')[0] ?? '00:00:00'),
            onPressed: () => context.read<PlayerCubit>().playEpisode(
              episode,
              initialPosition: parseDuration(transcript.startTime ?? '00:00:00.000'),
            ),
            icon: Icon(M3EIcons.play_arrow),
          ),
          Expanded(
            child: Padding(
              padding: .only(top: kIsWeb ? 0 : pu3, bottom: isBookmark ? pu3 : 9),
              child: Text('${transcript.speaker != null ? '${transcript.speaker}: ' : ''}${transcript.content}'),
            ),
          ),
        ],
      ),
    );
  }
}
