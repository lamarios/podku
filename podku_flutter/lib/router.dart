import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:podku/episodes/views/screens/episodes.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/home/views/screens/home.dart';
import 'package:podku/offline_episodes/views/screens/offline_episodes.dart';
import 'package:podku/player/views/screens/player_wrapper.dart';
import 'package:podku/podcasts/views/screens/podcast.dart';
import 'package:podku/podcasts/views/screens/podcasts.dart';
import 'package:podku/search/views/screens/search.dart';
import 'package:podku/server/views/screens/setup.dart';

GoRouter router(String? serverUrl) => GoRouter(
  initialLocation: serverUrl == null ? '/setup' : '/episodes',
  routes: [
    GoRoute(
      path: '/setup',
      builder: (context, state) => ServerSetupScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => PlayerWrapper(child: child),
      routes: [
        GoRoute(
          path: '/podcast/:podcastId',
          builder: (context, state) => PodcastScreen(
            podcastId: state.pathParameters['podcastId'],
          ),
        ),
        GoRoute(
          path: '/offline',
          builder: (context, state) => OfflineEpisodesScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BlocProvider(
              create: (context) => HomeCubit(HomeState(selectedIndex: 0)),
              child: HomeScreen(navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'Episodes',
                  path: '/episodes',
                  builder: (context, state) => EpisodeScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'Podcasts',
                  path: '/podcasts',
                  builder: (context, state) => PodcastsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: 'Search',
                  path: '/search',
                  builder: (context, state) => SearchScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
