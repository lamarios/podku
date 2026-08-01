import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:openapi/openapi.dart';

import 'package:podku/utils.dart';
import 'package:podku/episodes/views/components/download_status.dart';

class EpisodeSubTitle extends StatelessWidget {
  final Episode episode;
  final bool offline;
  final MainAxisAlignment? mainAxisAlignment;
  const EpisodeSubTitle({super.key, required this.episode, required this.offline, this.mainAxisAlignment});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: mainAxisAlignment ?? .start,
      children: [
        Text(
          DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(episode.pubDateMillis ?? 0)),
          style: textTheme.bodySmall?.copyWith(color: colors.outline),
        ),
        if (episode.durationSeconds != null) ...[
          Gap(pu2),
          Icon(Icons.timer_outlined, size: 12, color: colors.outline),
          Text(
            printDuration(Duration(seconds: episode.durationSeconds ?? 0)),
            style: textTheme.bodySmall?.copyWith(color: colors.outline),
          ),
        ],
        Gap(pu),
        if (!kIsWeb && !offline) EpisodeDownloadStatus(episode: episode),
      ],
    );
  }
}
