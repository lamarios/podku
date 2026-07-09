import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:podku_flutter/home/states/home.dart';
import 'package:podku_flutter/podcasts/states/podcasts.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(HomeState()),
        ),
        BlocProvider(
          create: (context) => PodcastsCubit(PodcastState()),
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: state.selectedIndex,
              destinations: [
                NavigationDestination(icon: Icon(Icons.playlist_play), label: 'Episodes'),
                NavigationDestination(icon: Icon(Icons.podcasts), label: 'Podcasts'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
              ],
              onDestinationSelected: (value) {
                switch (value) {
                  case 0:
                    context.go('/episodes');
                    break;
                  case 1:
                    context.go('/podcasts');
                    break;
                  case 2:
                    context.go('/search');
                    break;
                }
                cubit.setIndex(value);
              },
            ),
          );
        },
      ),
    );
  }
}
