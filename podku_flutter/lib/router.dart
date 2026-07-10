import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podku_flutter/episodes/views/screens/episodes.dart';
import 'package:podku_flutter/home/views/screens/home.dart';
import 'package:podku_flutter/player/views/screens/player_wrapper.dart';
import 'package:podku_flutter/podcasts/views/screens/podcast.dart';
import 'package:podku_flutter/podcasts/views/screens/podcasts.dart';
import 'package:podku_flutter/search/views/screens/search.dart';
import 'package:podku_flutter/server/views/screens/setup.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();

GoRouter router(String? serverUrl) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: serverUrl == null ? '/setup' : '/episodes',
  routes: [
    GoRoute(
      path: '/setup',
      builder: (context, state) => ServerSetupScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => PlayerWrapper(child: child),
      routes: [
        GoRoute(path: '/podcast/:podcastId',
          builder: (context, state) => PodcastScreen(podcastId: state.pathParameters['podcastId'],),
        ),
        ShellRoute(
          navigatorKey: _homeNavigatorKey,
          builder: (context, state, child) => HomeScreen(child: child),
          routes: [
            GoRoute(
              path: '/podcasts',
              parentNavigatorKey: _homeNavigatorKey,
              builder: (context, state) => PodcastsScreen(),
            ),
            GoRoute(
              path: '/search',
              parentNavigatorKey: _homeNavigatorKey,
              builder: (context, state) => SearchScreen(),
            ),
            GoRoute(
              path: '/episodes',
              parentNavigatorKey: _homeNavigatorKey,
              builder: (context, state) => EpisodeScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
