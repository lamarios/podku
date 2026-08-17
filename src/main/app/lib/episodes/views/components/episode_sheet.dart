import 'package:flutter/foundation.dart';
import 'package:share_link/share_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/people_wrap.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/bottom_sheet_title.dart';
import 'package:podku/utils/views/components/description.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeSheet extends StatelessWidget {
  final Episode episode;
  final bool offline;
  final bool showTitle;

  const EpisodeSheet({super.key, required this.episode, required this.offline, this.showTitle = true});

  static Future<Object?> open(BuildContext context, Episode episode, bool offline) async {
    final isMobile = BreakPoint.of(context) == .mobile;

    return isMobile
        ? M3EBottomSheet.show(
            context,
            showDragHandle: false,
            builder: (context) => SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
                child: EpisodeSheet(episode: episode, offline: offline),
              ),
            ),
          )
        : M3EDialog.show(
            context,
            dialog: M3EDialog(
              // backgroundColor: Colors.transparent,
              // constraints: BoxConstraints(maxWidth: 400, maxHeight: 700),
              icon: PodcastImage(podcastLight: episode.podcast, width: 50, height: 50, borderRadius: pu2),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                child: EpisodeSheet(episode: episode, offline: offline, showTitle: false),
              ),
              title: episode.title ?? '',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final locals = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: .all(pu2),
        child: Column(
          mainAxisSize: .min,
          spacing: pu2,
          children: [
            if (showTitle)
              BottomSheetTitle(
                title: episode.title ?? '',
                icon: PodcastImage(podcastLight: episode.podcast!, width: 30, height: 30, borderRadius: pu),
              ),
            PeopleList(episode: episode, wrap: true, size: 50, nameStyle: textTheme.bodySmall),
            Flexible(
              fit: .loose,
              child: SingleChildScrollView(
                child: Padding(
                  padding: .all(pu2),
                  child: HtmlDescription(episode: episode, offline: offline),
                ),
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
                      if (kIsWeb) {
                        launchUrl(Uri.parse(episode.audioUrl ?? ''));
                      } else {
                        context.read<DownloadManagerCubit>().download(episode, manualDownload: true);
                        Navigator.of(context).pop();
                      }
                    },
                    label: Text(locals.download),
                    icon: Icon(Icons.download),
                  ),
                TextButton.icon(
                  onPressed: () => ShareLink.shareUri(Uri.parse(episode.audioUrl!)),
                  icon: Icon(Icons.share),
                  label: Text(locals.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
