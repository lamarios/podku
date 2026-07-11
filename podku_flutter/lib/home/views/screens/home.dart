import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/server/states/server.dart';

import '../../../utils.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  static const _titles = ['Episodes', 'Podcasts', 'Search'];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PodcastsCubit(PodcastState()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[navigationShell.currentIndex]),
          actions: [
            IconButton(
              onPressed: () async {
                await getIt.get<ServerCubit>().setServerUrl(null);
                if (context.mounted) {
                  context.go('/setup');
                }
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: .symmetric(horizontal: pu2),
            child: KeyedSubtree(key: ValueKey(navigationShell.currentIndex), child: navigationShell),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          destinations: [
            NavigationDestination(icon: Icon(Icons.playlist_play), label: 'Episodes'),
            NavigationDestination(icon: Icon(Icons.podcasts), label: 'Podcasts'),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          ],
          onDestinationSelected: (value) {
            navigationShell.goBranch(value);
            context.read<HomeCubit>().setIndex(value);
          },
        ),
      ),
    );
  }
}
