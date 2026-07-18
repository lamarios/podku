import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:podku_client/podku_client.dart';

import '../../../utils.dart';
import 'download_status.dart';

class EpisodeSubTitle extends StatelessWidget {
  final Episode episode;
  final bool offline;
  const EpisodeSubTitle({super.key, required this.episode, required this.offline});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: .center,
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
