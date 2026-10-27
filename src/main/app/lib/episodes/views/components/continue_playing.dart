import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:podku/episodes/states/continue_playing.dart';
import 'package:podku/episodes/views/components/episode_in_continue_playing.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/utils.dart';

class ContinuePlaying extends StatelessWidget {
  const ContinuePlaying({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => ContinuePlayingCubit(ContinuePlayingState()),

      child: BlocBuilder<ContinuePlayingCubit, ContinuePlayingState>(
        builder: (context, state) {
          if (state.loading) {
            return Align(
              alignment: .centerLeft,
              child: SizedBox(width: 50, height: 50, child: LoadingIndicator()),
            );
          } else if (state.episodes.isEmpty) {
            return SizedBox.shrink();
          } else {
            return Column(
              crossAxisAlignment: .stretch,
              spacing: pu2,
              children: [
                Text(locals.continuePlaying),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    itemCount: state.episodes.length,
                    scrollDirection: .horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: .only(right: pu4),
                      child: EpisodeInContinuePlaying(episode: state.episodes[index], offline: false, height: 80),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
