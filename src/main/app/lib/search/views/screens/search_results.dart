import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/search/controllers/m3e_search_controller.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/podcasts/states/podcasts.dart';
import 'package:podku/search/states/search_popup.dart';
import 'package:podku/search/views/components/search_result.dart';

class SearchResults extends StatelessWidget {
  final M3ESearchController controller;

  const SearchResults({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => SearchPopupCubit(SearchPopupState(), searchController: controller),
      child: BlocBuilder<SearchPopupCubit, SearchPopupState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: .min,
            children: [
              Text(locals.discoverNewPodcasts),
              ...state.discoverResults.map(
                (result) => SearchResultView(
                  result: result,
                  subscribed: context.read<PodcastsCubit>().state.subscriptions.any(
                    (element) => element.url == result.feedUrl,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
