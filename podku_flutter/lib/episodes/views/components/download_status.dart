import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku_client/podku_client.dart';

class EpisodeDownloadStatus extends StatelessWidget {
  static final _log = Logger('EpisodeDownloadStatus');
  static const double _iconHeight = 15;
  final Episode episode;

  const EpisodeDownloadStatus({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final download = context.select(
          (DownloadManagerCubit c) => c.state.downloadStatus[episode.id.uuid],
        );

        _log.fine('download status for ${episode.title}: ${download?.status}');
        if (download == null) {
          return SizedBox.shrink();
        }

        return switch (download.status) {
          .enqueued => Icon(
            Icons.download,
            size: _iconHeight,
            color: colors.outline,
          ),
          .running => Row(
            children: [
              Icon(
                    Icons.download,
                    size: _iconHeight,
                    color: colors.outline,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .tint(color: Colors.green, duration: Duration(seconds: 1)),
              Text('${(download.progress * 100).toStringAsFixed(0)}%', style: textTheme.bodySmall?.copyWith(color: colors.outline),),
            ],

          ),
          .complete => Icon(
            Icons.download,
            size: _iconHeight,
            color: Colors.green,
          ),
          _ => SizedBox.shrink(),
        };
      },
    );
  }
}
