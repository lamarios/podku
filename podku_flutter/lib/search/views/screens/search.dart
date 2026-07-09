import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku_flutter/podcasts/states/podcasts.dart';
import 'package:podku_flutter/search/states/search.dart';
import 'package:podku_flutter/search/views/components/search_result.dart';
import 'package:podku_flutter/utils.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(SearchState()),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final subscriptions = context.select((PodcastsCubit c) => c.state.subscriptions).map((s) => s.url).toList();
          final cubit = context.read<SearchCubit>();
          return Column(
            children: [
              TextField(controller: cubit.searchController),
              Expanded(
                child: ListView.builder(
                  itemCount: state.results.length,
                  padding: EdgeInsets.all(pu2),

                  itemBuilder: (context, index) {
                    final r = state.results[index];
                    return Padding(
                      key: ValueKey(r),
                      padding: .only(bottom: pu2),
                      child: SearchResultView(result: r, subscribed: subscriptions.contains(r.feedUrl)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
