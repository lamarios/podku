import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/home/states/home.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_manager.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils/dialogs.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku/utils/views/components/error_listener.dart';

import '../../../utils.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    final titles = [locals.episodes, locals.podcasts, locals.search];

    bool isMobile = BreakPoint.get(context) == .mobile;
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PodcastsCubit(PodcastState()))],
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[navigationShell.currentIndex]),
          actions: [
            if (!kIsWeb) IconButton(onPressed: () => context.push('/offline'), icon: Icon(Icons.download)),
            if (!kIsWeb || kDebugMode)
              IconButton(
                onPressed: () async {
                  if (await okCancelDialog(context, title: locals.loggingOut, content: Text(locals.loggingOutText)) ??
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
        ),
        body: BlocBuilder<ServerCubit, ServerState>(
          builder: (context, state) {
            return ErrorHandler<PodcastsCubit, PodcastState>(
              child: SafeArea(
                child: state.client == null
                    ? Center(child: LoadingIndicator())
                    : ConditionalWrap(
                        wrapIf: !isMobile,
                        wrapper: (child) => Row(
                          crossAxisAlignment: .stretch,
                          children: [
                            NavigationRail(
                              extended: true,
                              destinations: [
                                NavigationRailDestination(
                                  icon: Icon(Icons.playlist_play),
                                  label: Text(locals.episodes),
                                ),
                                NavigationRailDestination(icon: Icon(Icons.podcasts), label: Text(locals.podcasts)),
                                NavigationRailDestination(icon: Icon(Icons.search), label: Text(locals.search)),
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
                          child: KeyedSubtree(key: ValueKey(navigationShell.currentIndex), child: navigationShell),
                        ),
                      ),
              ),
            );
          },
        ),
        bottomNavigationBar: isMobile
            ? NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                destinations: [
                  NavigationDestination(icon: Icon(Icons.playlist_play), label: locals.episodes),
                  NavigationDestination(icon: Icon(Icons.podcasts), label: locals.podcasts),
                  NavigationDestination(icon: Icon(Icons.search), label: locals.search),
                ],
                onDestinationSelected: (value) {
                  navigationShell.goBranch(value);
                  context.read<HomeCubit>().setIndex(value);
                },
              )
            : null,
      ),
    );
  }
}
