import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/l10n/app_localizations.dart';
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
              Positioned(
                bottom: pu3,
                right: pu3,
                child: FloatingActionButton.extended(
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
                  label: Text(locals.addPodcastFromUrl),
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
