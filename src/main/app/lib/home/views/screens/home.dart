import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/navigation_bar/m3e_navigation_bar.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/components/navigation_rail/m3e_navigation_rail.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_destination.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_section.dart';
import 'package:material_3_expressive/components/search/controllers/m3e_search_controller.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/search/model/global_search_result.dart';
import 'package:podku/search/service/search.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/dialogs.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/error_listener.dart';

Timer? _debounce;

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    final colors = M3ETheme.of(context).colorScheme;
    final titles = [locals.episodes, locals.podcasts, locals.search];

    bool isMobile = BreakPoint.of(context) == .mobile;
    return M3ETheme(
      data: M3EThemeData.dark(),
      dynamicColoring: !kIsWeb,
      autoTheming: true,
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => PodcastsCubit(PodcastState()))],
        child: Builder(
          builder: (originalContext) {
            return Scaffold(
              appBar: M3EAppBar.search(
                leading: Row(
                  children: [
                    SvgPicture.asset('assets/podku-icon-no-background.svg', width: 50, height: 50),
                    if (!isMobile) Text(titles[navigationShell.currentIndex]),
                  ],
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                isFullScreen: false,
                barBackgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLowest),
                barHintText: locals.search,
                density: .compact,
                actions: [
                  if (!kIsWeb) IconButton(onPressed: () => context.push('/offline'), icon: Icon(Icons.download)),
                  if (!kIsWeb || kDebugMode)
                    IconButton(
                      onPressed: () async {
                        if ((await okCancelDialog(
                              context,
                              title: locals.loggingOut,
                              content: Text(locals.loggingOutText),
                            )) ??
                            false) {
                          await getIt.get<ServerCubit>().setServerUrl(null);
                          if (context.mounted) {
                            await context.read<DownloadManagerCubit>().deleteAllEpisodes();
                            if (context.mounted) {
                              context.go('/setup');
                            }
                          }
                        }
                      },
                      icon: Icon(Icons.logout),
                    ),
                ],

                searchController: context.read<HomeCubit>().searchController,
                suggestionsBuilder: (BuildContext context, M3ESearchController controller) async {
                  final query = controller.text;
                  if (query.trim().isEmpty) return [];

                  // Debounce: wait, then bail out if the text has already changed
                  final completer = Completer<void>();
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), completer.complete);
                  await completer.future;
                  if (controller.text != query) return [];

                  final results = await SearchService().search(query);
                  if (results.isEmpty) {
                    return [const ListTile(title: Text('No results found'))];
                  }

                  return _buildSections(originalContext, results, controller);
                },
              ),
              body: BlocBuilder<ServerCubit, ServerState>(
                builder: (context, state) {
                  return ErrorHandler<PodcastsCubit, PodcastState>(
                    showAsSnack: true,
                    child: SafeArea(
                      child: state.client == null
                          ? Center(child: LoadingIndicator())
                          : ConditionalWrap(
                              wrapIf: !isMobile,
                              wrapper: (child) => Row(
                                crossAxisAlignment: .stretch,
                                children: [
                                  M3ENavigationRail(
                                    labelBehavior: .alwaysShow,
                                    sections: [
                                      M3ENavigationRailSection(
                                        destinations: [
                                          M3ENavigationRailDestination(
                                            icon: Icon(M3EIcons.playlist_play),
                                            label: locals.episodes,
                                          ),
                                          M3ENavigationRailDestination(
                                            icon: Icon(M3EIcons.podcasts),
                                            label: locals.podcasts,
                                          ),
                                        ],
                                      ),
                                    ],
                                    selectedIndex: navigationShell.currentIndex,
                                    onDestinationSelected: (value) {
                                      navigationShell.goBranch(value);
                                      context.read<HomeCubit>().setIndex(value);
                                    },
                                  ),
                                  Expanded(child: child),
                                ],
                              ),
                              child: Padding(
                                padding: .symmetric(horizontal: pu2),
                                child: KeyedSubtree(
                                  key: ValueKey(navigationShell.currentIndex),
                                  child: navigationShell,
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
              bottomNavigationBar: isMobile
                  ? M3ENavigationBar(
                      selectedIndex: navigationShell.currentIndex,
                      destinations: [
                        M3ENavigationBarDestination(icon: Icon(M3EIcons.playlist_play), label: locals.episodes),
                        M3ENavigationBarDestination(icon: Icon(M3EIcons.podcasts), label: locals.podcasts),
                      ],
                      onDestinationSelected: (value) {
                        navigationShell.goBranch(value);
                        context.read<HomeCubit>().setIndex(value);
                      },
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context, List<GlobalSearchResult> results, M3ESearchController controller) {
    final locals = AppLocalizations.of(context)!;

    final podcasts = results.where((r) => r.type == SearchResultType.podcast).toList();
    final episodes = results.where((r) => r.type == SearchResultType.episode).toList();
    final discover = results.where((r) => r.type == SearchResultType.discovert).toList();

    return [
      if (discover.isNotEmpty) ..._section(context, locals.discoverNewPodcasts, discover, controller),
      if (podcasts.isNotEmpty) ..._section(context, locals.yourPodcasts, podcasts, controller),
      if (episodes.isNotEmpty) ..._section(context, locals.yourEpisodes, episodes, controller),
      ListTile(
        leading: Icon(M3EIcons.travel_explore),
        title: Text(locals.openSearch),
        onTap: () {
          controller.closeView(controller.text);
          context.push('/search', extra: controller.text).then((value) {
            if (context.mounted) {
              context.read<PodcastsCubit>().getPodcasts();
            }
          });
        },
      ),
    ];
  }

  List<Widget> _section(
    BuildContext context,
    String label,
    List<GlobalSearchResult> items,
    M3ESearchController controller,
  ) {
    return [
      Padding(
        padding: .symmetric(horizontal: pu2, vertical: pu2),
        child: Text(label),
      ),
      ...items.map(
        (r) => Padding(
          padding: .symmetric(vertical: pu),
          child: ListTile(
            leading: _iconFor(r),
            title: Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: r.subtitle != null ? Text(r.subtitle!) : null,
            onTap: () {
              controller.closeView(controller.text);
              _handleTap(context, r);
            },
          ),
        ),
      ),
    ];
  }

  void _handleTap(BuildContext context, GlobalSearchResult r) {
    switch (r.type) {
      case .podcast:
        context.push('/podcast/${(r as GlobalSearchResult<PodcastLight>).data.id}').then((value) {
          if (context.mounted) {
            context.read<PodcastsCubit>().getPodcasts();
          }
        });
        break;
      case .episode:
        EpisodeSheet.open(context, (r as GlobalSearchResult<Episode>).data, false);
        break;
      case .discovert:
        context.push('/search/result', extra: (r as GlobalSearchResult<SearchResult>).data).then((value) {
          if (context.mounted) {
            context.read<PodcastsCubit>().getPodcasts();
          }
        });
        break;
    }
  }

  Widget _iconFor(GlobalSearchResult result) {
    final double imageSize = 60;
    final radius = pu;
    return switch (result.type) {
      .discovert => PodcastImage(
        width: imageSize,
        height: imageSize,
        borderRadius: radius,
        podcastLight: PodcastLight(artworkUrl: (result as GlobalSearchResult<SearchResult>).data.artworkUrl600),
      ),
      .podcast => PodcastImage(
        width: imageSize,
        height: imageSize,
        borderRadius: radius,
        podcastLight: (result as GlobalSearchResult<PodcastLight>).data,
      ),
      .episode => PodcastImage(
        width: imageSize,
        height: imageSize,
        borderRadius: radius,
        podcastLight: (result as GlobalSearchResult<Episode>).data.podcast,
      ),
    };
  }
}
