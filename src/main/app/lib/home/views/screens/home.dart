import 'dart:async';
import 'dart:ui';

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
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/episodes/views/components/episode_sheet.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/player/states/player.dart';
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

/// number of navigation shell branches (episodes, podcasts, bookmarks), rail items after these are actions
const int _branchCount = 3;

class HomeScreen extends StatelessWidget {
  static double navigationPadding(BuildContext context) => BreakPoint.of(context) == .mobile ? 120 : 0;

  static SliverPadding mobileNavigationPadding(BuildContext context) {
    return SliverPadding(padding: .only(bottom: navigationPadding(context)));
  }

  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    final colors = M3ETheme.of(context).colorScheme;

    bool isMobile = BreakPoint.of(context) == .mobile;
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PodcastsCubit(PodcastState()))],
      child: Builder(
        builder: (originalContext) {
          return Scaffold(
            // tablet / desktop have no app bar, the logo, search, downloads and logout live in the navigation rail
            appBar: isMobile
                ? M3EAppBar.search(
                    leading: Padding(
                      padding: .symmetric(horizontal: pu4),
                      child: SvgPicture.asset('assets/podku-icon-no-background.svg', width: 30, height: 30),
                    ),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    isFullScreen: isMobile,
                    barBackgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLowest),
                    barHintText: locals.search,
                    density: .compact,
                    onOpen: () => context.read<PlayerCubit>().setHidePlayers(true),
                    onClose: () => context.read<PlayerCubit>().setHidePlayers(false),
                    actions: [
                      if (!kIsWeb) IconButton(onPressed: () => context.push('/offline'), icon: Icon(Icons.download)),
                      if (!kIsWeb || kDebugMode)
                        IconButton(onPressed: () => _logout(context), icon: Icon(Icons.logout)),
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
                  )
                : null,
            body: BlocBuilder<ServerCubit, ServerState>(
              builder: (context, state) {
                final railExpanded = context.select((HomeCubit c) => c.state.railExpanded);
                return ErrorHandler<PodcastsCubit, PodcastState>(
                  showAsSnack: true,
                  child: SafeArea(
                    bottom: false,
                    child: state.client == null
                        ? Center(child: LoadingIndicator())
                        : ConditionalWrap(
                            wrapIf: isMobile,
                            wrapper: (child) => Stack(
                              children: [
                                child,
                                Positioned(
                                  left: pu4,
                                  right: pu4,
                                  bottom: pu2,
                                  child: SafeArea(
                                    child: M3ENavigationBar(
                                      // density: .compact,
                                      // size: .small,
                                      shapeFamily: .round,
                                      selectedIndex: navigationShell.currentIndex,
                                      destinations: [
                                        M3ENavigationBarDestination(
                                          icon: Icon(M3EIcons.playlist_play),
                                          label: locals.episodes,
                                        ),
                                        M3ENavigationBarDestination(
                                          icon: Icon(M3EIcons.podcasts),
                                          label: locals.podcasts,
                                        ),
                                        M3ENavigationBarDestination(
                                          icon: Icon(M3EIcons.bookmarks),
                                          label: locals.bookmarks,
                                        ),
                                      ],
                                      onDestinationSelected: (value) {
                                        navigationShell.goBranch(value);
                                        context.read<HomeCubit>().setIndex(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: ConditionalWrap(
                              wrapIf: !isMobile,
                              wrapper: (child) => Row(
                                crossAxisAlignment: .stretch,
                                children: [
                                  Column(
                                    children: [
                                      // logo sits above the rail, section headers are hidden when the rail is collapsed
                                      Padding(
                                        padding: .symmetric(vertical: pu2),
                                        child: SingleMotionBuilder(
                                          motion: MaterialSpringMotion.expressiveSpatialFast(),
                                          value: railExpanded ? 1 : 0,
                                          builder: (context, value, child) {
                                            final logoSize = lerpDouble(30, 80, value)!;
                                            final textSize = lerpDouble(0, 30, value)!.clamp(0, 100000).toDouble();
                                            return Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/podku-icon-no-background.svg',
                                                  width: logoSize,
                                                  height: logoSize,
                                                ),
                                                Text('Podku', style: TextStyle(fontSize: textSize)),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: M3ENavigationRail(
                                          // the rail only reads type for its initial state, passing it keeps a rebuilt
                                          // rail (e.g. resizing from mobile to desktop) in sync with railExpanded
                                          type: railExpanded ? .expanded : .collapsed,
                                          onTypeChanged: (type) =>
                                              context.read<HomeCubit>().setRailExpanded(type == .expanded),
                                          labelBehavior: .alwaysShow,
                                          background: Colors.transparent,
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
                                                M3ENavigationRailDestination(
                                                  icon: Icon(M3EIcons.bookmarks),
                                                  label: locals.bookmarks,
                                                ),
                                                // the items below open a screen instead of switching branch
                                                M3ENavigationRailDestination(
                                                  icon: Icon(M3EIcons.search),
                                                  label: locals.search,
                                                ),
                                                if (!kIsWeb)
                                                  M3ENavigationRailDestination(
                                                    icon: Icon(M3EIcons.download),
                                                    label: locals.downloads,
                                                  ),
                                              ],
                                            ),
                                          ],
                                          selectedIndex: navigationShell.currentIndex,
                                          onDestinationSelected: (value) {
                                            if (value < _branchCount) {
                                              navigationShell.goBranch(value);
                                              context.read<HomeCubit>().setIndex(value);
                                              return;
                                            }

                                            final actions = <VoidCallback>[
                                              () => _openSearch(context),
                                              if (!kIsWeb) () => context.push('/offline'),
                                            ];
                                            actions[value - _branchCount]();
                                          },
                                          trailing: !kIsWeb || kDebugMode
                                              ? IconButton(
                                                  tooltip: locals.logout,
                                                  onPressed: () => _logout(context),
                                                  icon: Icon(M3EIcons.logout),
                                                )
                                              : null,
                                        ),
                                      ),
                                    ],
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
                  ),
                );
              },
            ),
            /*
            bottomNavigationBar: isMobile
                ? M3ENavigationBar(
                    selectedIndex: navigationShell.currentIndex,
                    destinations: [
                      M3ENavigationBarDestination(icon: Icon(M3EIcons.playlist_play), label: locals.episodes),
                      M3ENavigationBarDestination(icon: Icon(M3EIcons.podcasts), label: locals.podcasts),
                      M3ENavigationBarDestination(icon: Icon(M3EIcons.bookmarks), label: locals.bookmarks),
                    ],
                    onDestinationSelected: (value) {
                      navigationShell.goBranch(value);
                      context.read<HomeCubit>().setIndex(value);
                    },
                  )
                : null,
*/
          );
        },
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
          _openSearch(context, query: controller.text);
        },
      ),
    ];
  }

  void _openSearch(BuildContext context, {String? query}) {
    context.push('/search', extra: query).then((value) {
      if (context.mounted) {
        context.read<PodcastsCubit>().getPodcasts();
      }
    });
  }

  Future<void> _logout(BuildContext context) async {
    final locals = AppLocalizations.of(context)!;
    if ((await okCancelDialog(context, title: locals.loggingOut, content: Text(locals.loggingOutText))) ?? false) {
      await getIt.get<ServerCubit>().setServerUrl(null);
      if (context.mounted) {
        await context.read<DownloadManagerCubit>().deleteAllEpisodes();
        if (context.mounted) {
          context.go('/setup');
        }
      }
    }
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
        EpisodeSheet.open(context, (r as GlobalSearchResult<EpisodeSearchResult>).data.episode!, false);
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
        podcastLight: PodcastLight(
          artworkUrl: (result as GlobalSearchResult<SearchResult>).data.artworkUrl600,
          artworkEncrypted: (result).data.artworkUrlEncrypted,
        ),
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
        podcastLight: (result as GlobalSearchResult<EpisodeSearchResult>).data.episode?.podcast,
      ),
    };
  }
}
