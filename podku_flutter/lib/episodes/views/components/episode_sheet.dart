import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku_client/podku_client.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

class EpisodeSheet extends StatelessWidget {
  final Episode episode;
  final bool offline;

  const EpisodeSheet({super.key, required this.episode, required this.offline});

  static Future<Object?> open(BuildContext context, Episode episode, bool offline) async {
    final isMobile = BreakPoint.get(context) == .mobile;

    return isMobile
        ? Navigator.of(context).push(
            StupidSimpleSheetRoute(
              draggable: true,
              barrierDismissible: true,
              motion: MaterialSpringMotion.expressiveSpatialDefault(),
              child: SafeArea(
                child: EpisodeSheet(episode: episode, offline: offline),
              ),
            ),
          )
        : showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
              child: EpisodeSheet(episode: episode, offline: offline),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locals = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: .all(pu4),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(pu6),
          border: Border.all(color: colors.secondaryContainer.withValues(alpha: 0.75), width: 1),
          boxShadow: [BoxShadow(color: colors.surface, spreadRadius: pu, blurRadius: pu4)],
        ),
        child: Padding(
          padding: .all(pu2),
          child: Column(
            mainAxisSize: .min,
            children: [
              Row(
                crossAxisAlignment: .center,
                children: [
                  if (episode.podcast != null)
                    PodcastImage(podcast: episode.podcast!, width: 30, height: 30, borderRadius: pu),
                  Gap(pu),
                  Expanded(
                    child: Text(episode.title, maxLines: 1, overflow: .ellipsis, style: textTheme.titleMedium),
                  ),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close)),
                ],
              ),

              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Padding(padding: .all(pu2), child: HtmlWidget(episode.description ?? '')),
                ),
              ),

              Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      context.read<PlayerCubit>().playEpisode(episode, offline: offline);
                      Navigator.of(context).pop();
                    },
                    label: Text(locals.play),
                    icon: Icon(Icons.play_arrow),
                  ),
                  if (!offline)
                    TextButton.icon(
                      onPressed: () {
                        context.read<DownloadManagerCubit>().download(episode, manualDownload: true);
                        Navigator.of(context).pop();
                      },
                      label: Text(locals.download),
                      icon: Icon(Icons.download),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
