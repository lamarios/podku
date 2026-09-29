import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/utils.dart';

class EpisodeGridSubText extends StatelessWidget {
  final Episode episode;
  final bool offline;

  const EpisodeGridSubText({super.key, required this.episode, required this.offline});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return RichText(
      maxLines: 5,
      overflow: .ellipsis,
      text: TextSpan(
        text: DateFormat.MMMd().format(DateTime.fromMillisecondsSinceEpoch(episode.pubDateMillis ?? 0)),
        style: textTheme.bodyMedium?.copyWith(color: colors.onSurface, fontWeight: .bold),
        children: [
          if (episode.durationSeconds != null) ...[
            TextSpan(text: ' - '),
            TextSpan(text: printDuration(Duration(seconds: episode.durationSeconds ?? 0))),
          ],
          if (episode.description != null && episode.description!.isNotEmpty) ...[
            TextSpan(text: ' - '),
            TextSpan(
              text: Bidi.stripHtmlIfNeeded(episode.description ?? ''),
              style: textTheme.bodyMedium?.copyWith(color: colors.onPrimaryContainer),
            ),
          ],
        ],
      ),
    );
  }
}
