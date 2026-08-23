import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/components/search/controllers/m3e_search_controller.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/bookmarks/views/screens/bookmark_screen.dart';
import 'package:podku/bookmarks/views/screens/bookmarks_screen.dart';
import 'package:podku/episodes/views/screens/episodes.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/home/views/screens/home.dart';
import 'package:podku/offline_episodes/views/screens/download_settings.dart';
import 'package:podku/offline_episodes/views/screens/offline_episodes.dart';
import 'package:podku/player/views/screens/player_wrapper.dart';
import 'package:podku/podcasts/views/screens/podcast.dart';
import 'package:podku/podcasts/views/screens/podcasts.dart';
import 'package:podku/search/views/screens/search.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/server/views/screens/setup.dart';
import 'package:podku/utils/router/go_route_refresh_stream.dart';

final navigatorKey = GlobalKey<NavigatorState>();

GoRouter router(ServerCubit serverCubit) => GoRouter(
  navigatorKey: navigatorKey,
  refreshListenable: GoRouterRefreshStream(serverCubit.stream),
  redirect: (context, state) {
    final serverUrl = serverCubit.state.serverUrl;
    final goingToSetup = state.matchedLocation == '/setup';

    if (serverUrl == null && !goingToSetup) return '/setup';
    if (serverUrl != null && goingToSetup) return '/home/episodes';
    return null; // no redirect
  },
  initialLocation: '/home/episodes',
  routes: [
    GoRoute(path: '/setup', builder: (context, state) => ServerSetupScreen()),
    ShellRoute(
      builder: (context, state, child) => PlayerWrapper(routerState: state, child: child),
      routes: [
        GoRoute(
          path: '/podcast/:podcastId',
          builder: (context, state) => PodcastScreen(podcastId: state.pathParameters['podcastId']),
        ),
        GoRoute(
          path: '/search/result',
          builder: (context, state) => PodcastScreen(searchResult: state.extra as SearchResult),
        ),
        GoRoute(
          path: '/offline',
          builder: (context, state) => OfflineEpisodesScreen(),
          routes: [GoRoute(path: '/settings', builder: (context, state) => DownloadSettingsScreen())],
        ),
        GoRoute(
          path: '/bookmark/:id',
          builder: (context, state) => BookmarkScreen(bookmarkId: state.pathParameters['id']),
        ),
        GoRoute(
          name: 'Search',
          path: '/search',
          builder: (context, state) => SearchScreen(query: state.extra != null ? state.extra as String : null),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BlocProvider(
              create: (context) => HomeCubit(HomeState(selectedIndex: 0), searchController: M3ESearchController()),
              child: HomeScreen(navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [GoRoute(name: 'Episodes', path: '/home/episodes', builder: (context, state) => EpisodeScreen())],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(name: 'Podcasts', path: '/home/podcasts', builder: (context, state) => PodcastsScreen()),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(name: 'Bookmarks', path: '/home/bookmarks', builder: (context, state) => BookmarksScreen()),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
