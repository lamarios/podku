import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/cards/m3e_cards.dart';
import 'package:material_3_expressive/components/lists/components/m3e_card_list_item.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/duration_utils.dart';

final double _imageSize = 75;

class BookmarkInList extends StatelessWidget {
  final BookmarkWithTranscript bookmark;

  const BookmarkInList({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: .only(bottom: pu, top: pu),
      child: M3ECard(
        elevation: 0,
        child: Column(
          spacing: pu,
          children: [
            Row(
              spacing: pu2,
              children: [
                if (bookmark.bookmark?.episode?.podcast != null)
                  PodcastImage(
                    podcastLight: bookmark.bookmark!.episode!.podcast,
                    width: _imageSize,
                    height: _imageSize,
                    borderRadius: pu2,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      if ((bookmark.bookmark?.time ?? 0) > 0)
                        Row(
                          spacing: pu,
                          children: [
                            Icon(M3EIcons.access_time, size: 12, color: colors.secondary),
                            Text(
                              formatDuration(Duration(seconds: bookmark.bookmark!.time!)),
                              style: textTheme.bodySmall?.copyWith(color: colors.secondary),
                            ),
                          ],
                        ),
                      Text(bookmark.bookmark?.episode?.title ?? ''),
                    ],
                  ),
                ),
              ],
            ),
            if (bookmark.bookmark?.topic?.isNotEmpty ?? false)
              Padding(
                padding: .symmetric(vertical: pu),
                child: Row(
                  spacing: pu,
                  children: [
                    Icon(M3EIcons.auto_awesome, size: 17, color: colors.primary),
                    Expanded(
                      child: Text(
                        bookmark.bookmark?.topic ?? '',
                        style: textTheme.bodyMedium?.copyWith(color: colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            if (bookmark.transcripts?.values.firstOrNull?.isNotEmpty ?? false)
              M3ECardListItem(
                // headline: bookmark.transcripts!.values.first.first.content ?? '',
                // leading: Icon(M3EIcons.comment_outlined, color: colors.outline, size: 11), index: 0, position: 0, outerRadius: 0, innerRadius: 0, gap: 0, child: 0,
                index: 0,
                position: .single,
                outerRadius: pu2,
                innerRadius: pu2,
                gap: 0,
                child: Row(
                  crossAxisAlignment: .center,
                  spacing: pu,
                  children: [
                    Icon(M3EIcons.comment_outlined, color: colors.outline, size: 11),
                    Expanded(
                      child: Text(
                        bookmark.transcripts!.values.first.first.content ?? '',
                        style: textTheme.labelSmall?.copyWith(color: colors.outline),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
