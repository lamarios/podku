import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_3_expressive/components/bottom_sheets/m3e_bottom_sheets.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/components/dialogs/m3e_dialogs.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/podcasts/states/podcast_from_url.dart';
import 'package:podku/podcasts/views/components/podcast_image.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

class NewPodcastDialog extends StatelessWidget {
  const NewPodcastDialog({super.key});

  static Future<Podcast?> show(BuildContext context) async {
    final isMobile = BreakPoint.of(context) == .mobile;

    final locals = AppLocalizations.of(context)!;

    if (isMobile) {
      return M3EBottomSheet.show(
        context,
        builder: (context) => SafeArea(top: false, bottom: true, child: NewPodcastDialog()),
      );
    } else {
      return M3EDialog.show(
        context,
        dialog: M3EDialog(title: locals.addPodcastFromUrl, content: NewPodcastDialog()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final locals = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: BlocProvider(
          create: (context) => PodcastFromUrlCubit(PodcastFromUrlState()),
          child: BlocBuilder<PodcastFromUrlCubit, PodcastFromUrlState>(
            builder: (context, state) {
              final cubit = context.read<PodcastFromUrlCubit>();

              return SingleMotionBuilder(
                motion: MaterialSpringMotion.expressiveSpatialDefault(),
                from: 160,
                value: switch (state.page) {
                  0 => 180,
                  1 => 400,
                  _ => 0,
                },
                builder: (context, value, child) {
                  return Container(
                    margin: .all(pu4),
                    padding: .all(pu2),
                    constraints: BoxConstraints(minWidth: 300),
                    height: value,
                    /*
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: .circular(pu6),
                      border: Border.all(color: colors.secondaryContainer.withValues(alpha: 0.75), width: 1),
                      boxShadow: [BoxShadow(color: colors.surface, spreadRadius: pu, blurRadius: pu4)],
                    ),
        */
                    child: child,
                  );
                },
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Row(
                      children: [Expanded(child: Text(locals.addPodcast, style: textTheme.titleMedium))],
                    ),
                    Expanded(
                      child: PageView(
                        controller: cubit.pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          state.loading ? Center(child: LoadingIndicator()) : _PodcastUrl(hasError: state.podcastError),
                          state.loading || state.podcast == null
                              ? Center(child: LoadingIndicator())
                              : _PodcastResult(podcast: state.podcast!),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PodcastUrl extends StatelessWidget {
  final bool hasError;

  const _PodcastUrl({required this.hasError});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PodcastFromUrlCubit>();
    final locals = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: Center(
            child: TextField(
              controller: cubit.controller,
              decoration: InputDecoration(
                label: Text(locals.podcastUrl),
                error: hasError ? Text(locals.podcastParsingError) : null,
              ),
            ),
          ),
        ),
        Gap(pu2),
        Row(
          mainAxisAlignment: .end,
          children: [
            TextButton.icon(
              onPressed: () => cubit.parsePodcast(),
              label: Text(locals.next),
              icon: Icon(Icons.arrow_forward),
              iconAlignment: .end,
            ),
          ],
        ),
      ],
    );
  }
}

class _PodcastResult extends StatelessWidget {
  final Podcast podcast;

  const _PodcastResult({required this.podcast});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    final colors = M3ETheme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;

    return Column(
      children: [
        Gap(pu),
        PodcastImage(podcast: podcast, width: 200, height: 200, borderRadius: pu4),
        Gap(pu),
        Text(podcast.name ?? '', style: textTheme.titleMedium),
        Text(
          locals.nEpisodes(podcast.episodes?.length ?? 0),
          style: textTheme.bodyMedium?.copyWith(color: colors.secondary),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => context.read<PodcastFromUrlCubit>().back(),
              label: Text(locals.back),
              icon: Icon(Icons.arrow_back),
              iconAlignment: .start,
            ),
            M3EButton.icon(
              size: .md,
              onPressed: () => Navigator.of(context).pop(podcast),
              label: Text(locals.addPodcast),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
