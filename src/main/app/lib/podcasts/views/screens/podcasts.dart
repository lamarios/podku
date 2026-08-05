import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/components/fab_menu/m3e_fab_menu.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/mini_player.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/new_podcast_dialog.dart';
import 'package:podku/podcasts/views/components/podcast.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/dialogs.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;

    return BlocBuilder<PodcastsCubit, PodcastState>(
      builder: (context, state) {
        final hasMiniPlayer = context.select((PlayerCubit c) => c.state.showMiniPlayer);
        return BlocListener<HomeCubit, HomeState>(
          listener: (context, state) => context.read<PodcastsCubit>().getPodcasts(),
          listenWhen: (previous, current) => current.selectedIndex == 1,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  Expanded(
                    child: state.subscriptions.isNotEmpty
                        ? CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: .only(bottom: 100),
                                sliver: SliverGrid.builder(
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    mainAxisExtent: 250,
                                  ),
                                  // mainAxisExtent: 250,
                                  itemCount: state.subscriptions.length,
                                  itemBuilder: (context, index) {
                                    final p = state.subscriptions[index];
                                    return PodcastInGrid(key: ValueKey(p), podcast: p);
                                  },
                                ),
                              ),
                              MiniPlayer.miniPlayerPadding(),
                            ],
                          )
                        : Center(
                            child: Icon(
                              Icons.podcasts_outlined,
                              size: 100,
                              color: colors.onSurface.withValues(alpha: 0.1),
                            ),
                          ),
                  ),
                ],
              ),
              SingleMotionBuilder(
                motion: MaterialSpringMotion.expressiveSpatialFast(),
                value: hasMiniPlayer ? 1 : 0,
                builder: (context, value, child) {
                  return Positioned(
                    bottom: lerpDouble(pu3, pu8 + MiniPlayer.playerSize, value),
                    right: pu3,
                    child: child!,
                  );
                },
                child: M3EFabMenu(
                  items: [
                    M3EFabMenuItem(
                      icon: Icon(Icons.download),
                      label: locals.downloadOpml,
                      onPressed: () async {
                        await context.read<PodcastsCubit>().downloadOpml();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locals.fileDownloaded)));
                        }
                      },
                    ),
                    M3EFabMenuItem(
                      icon: Icon(Icons.upload),
                      label: locals.importOpml,
                      onPressed: () async {
                        PlatformFile? result = await FilePicker.pickFile();

                        if (context.mounted && result != null) {
                          await context.read<PodcastsCubit>().uploadOpml(result);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locals.podcastImported)));
                          }
                        }
                      },
                    ),
                    M3EFabMenuItem(
                      onPressed: () async {
                        final podcast = await NewPodcastDialog.show(context);
                        if (context.mounted && podcast != null) {
                          await context.read<PodcastsCubit>().subscribe(
                            SearchResult(artistName: podcast.name, feedUrl: podcast.url),
                          );
                          if (context.mounted) {
                            okCancelDialog(context, title: locals.podcastAdded, content: Text(locals.podcastAddedText));
                          }
                        }
                      },
                      label: locals.addPodcastFromUrl,
                      icon: Icon(Icons.add),
                    ),
                    M3EFabMenuItem(
                      onPressed: () async {
                        context.push('/search', extra: "");
                      },
                      label: locals.searchForPodcasts,
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
