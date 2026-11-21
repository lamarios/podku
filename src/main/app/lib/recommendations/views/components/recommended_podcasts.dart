import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/foundations/theme/m3e_theme.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/recommendations/states/recommendations.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/app_action.dart';
import 'package:podku/utils/models/breakpoint.dart';

const double _imageSize = 110;
const int _placeholderCount = 4;

/// Horizontal list of the podcasts recommended for an episode, hidden when there are none.
class RecommendedPodcasts extends StatelessWidget {
  final String episodeId;

  const RecommendedPodcasts({super.key, required this.episodeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // a new cubit (and request) per episode
      key: ValueKey(episodeId),
      create: (context) => RecommendationsCubit(RecommendationsState(), episodeId: episodeId),
      child: const _RecommendedPodcasts(),
    );
  }
}

class _RecommendedPodcasts extends StatelessWidget {
  const _RecommendedPodcasts();

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final locals = AppLocalizations.of(context)!;
    final loading = context.select((RecommendationsCubit c) => c.state.loading);
    final recommendations = context.select((RecommendationsCubit c) => c.state.recommendations);

    return AnimatedSize(
      duration: animationDuration,
      curve: Curves.easeInOutQuad,
      alignment: .topCenter,
      child: !loading && recommendations.isEmpty
          ? const SizedBox(width: double.infinity)
          : Column(
              crossAxisAlignment: .stretch,
              children: [
                Padding(
                  padding: .symmetric(horizontal: pu4),
                  child: Text(locals.youMightAlsoLike, style: textTheme.titleMedium),
                ),
                Gap(pu2),
                SizedBox(
                  height: _imageSize + pu16,
                  child: AnimatedSwitcher(
                    duration: animationDuration,
                    child: ListView.separated(
                      key: ValueKey(loading),
                      scrollDirection: .horizontal,
                      padding: .symmetric(horizontal: pu4),
                      itemCount: loading ? _placeholderCount : recommendations.length,
                      separatorBuilder: (context, index) => Gap(pu3),
                      itemBuilder: (context, index) =>
                          loading ? const _Placeholder() : _RecommendedPodcast(result: recommendations[index]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _RecommendedPodcast extends StatelessWidget {
  final SearchResult result;

  const _RecommendedPodcast({required this.result});

  Future<void> _open(BuildContext context) async {
    final cubit = context.read<RecommendationsCubit>();
    final breakPoint = BreakPoint.of(context);
    // on small screens the big player covers the podcast screen
    if (breakPoint == .mobile || breakPoint == .tablet) {
      context.read<PlayerCubit>().showPlayers(true, false);
    }
    await context.push('/search/result', extra: result);
    // the podcast may have been subscribed to
    actionStream.add(.refreshPodcasts);
    actionStream.add(.refreshEpisodes);
    await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;

    return SizedBox(
      width: _imageSize,
      child: InkWell(
        borderRadius: .circular(pu4),
        onTap: () => _open(context),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            PodcastImage(
              podcastLight: PodcastLight(
                artworkUrl: result.artworkUrl600,
                artworkEncrypted: result.artworkUrlEncrypted,
                url: result.feedUrl ?? '',
                name: result.collectionName ?? '',
              ),
              width: _imageSize,
              height: _imageSize,
              borderRadius: pu4,
            ),
            Gap(pu),
            Text(result.collectionName ?? '', style: textTheme.labelLarge, maxLines: 2, overflow: .ellipsis),
            if (result.artistName?.isNotEmpty ?? false)
              Text(
                result.artistName!,
                style: textTheme.labelSmall?.copyWith(color: colors.outline),
                maxLines: 1,
                overflow: .ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          width: _imageSize,
          height: _imageSize,
          decoration: BoxDecoration(color: colors.surfaceContainerHighest, borderRadius: .circular(pu4)),
        ),
        Gap(pu),
        Container(
          width: _imageSize * 0.7,
          height: pu3,
          decoration: BoxDecoration(color: colors.surfaceContainerHighest, borderRadius: .circular(pu)),
        ),
      ],
    );
  }
}
