import 'package:anchored_list/anchored_list.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/foundations/theme/m3e_theme.dart';
import 'package:material_loading_indicator/loading_indicator.dart';
import 'package:motor/motor.dart';
import 'package:openapi/openapi.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/states/transcript.dart';
import 'package:podku/player/views/components/past_5_minute_summary.dart';
import 'package:podku/utils.dart';

class TranscriptFollower extends StatelessWidget {
  const TranscriptFollower({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    var colors = M3ETheme.of(context).colorScheme;
    final textTheme = M3ETheme.of(context).textTheme;
    return BlocProvider(
      create: (context) => TranscriptCubit(TranscriptState(), playerCubit: context.read<PlayerCubit>()),
      child: BlocBuilder<TranscriptCubit, TranscriptState>(
        builder: (context, state) {
          final cubit = context.read<TranscriptCubit>();
          final transcript = context.select((TranscriptCubit c) => c.state.transcript);
          return BlocListener<PlayerCubit, PlayerState>(
            listenWhen: (previous, current) => previous.episode != current.episode,
            listener: (context, state) => context.read<TranscriptCubit>().setEpisode(state.episode),
            child: transcript.isEmpty || state.index == -1 || state.loading
                ? Center(child: LoadingIndicator())
                : Padding(
                    padding: .symmetric(horizontal: pu8),
                    child: Stack(
                      children: [
                        Column(
                          spacing: pu,
                          children: [
                            if (state.selectedLanguage == 'a.i')
                              Row(
                                spacing: pu,
                                children: [
                                  Icon(Icons.auto_awesome, size: 15, color: colors.secondary),
                                  Text(locals.aiGeneratedTranscript, style: textTheme.labelSmall),
                                  Spacer(),
                                ],
                              ),
                            Expanded(
                              // fade the top and bottom of the list through its alpha channel so it works on
                              // top of a translucent / blurred background
                              child: ShaderMask(
                                blendMode: .dstIn,
                                shaderCallback: (bounds) {
                                  final fade = bounds.height == 0 ? 0.0 : (100 / bounds.height).clamp(0.0, 0.5);
                                  return LinearGradient(
                                    begin: .topCenter,
                                    end: .bottomCenter,
                                    colors: const [Colors.transparent, Colors.black, Colors.black, Colors.transparent],
                                    stops: [0, fade, 1 - fade, 1],
                                  ).createShader(bounds);
                                },
                                child: AnchoredList.builder(
                                  controller: cubit.listController,
                                  itemCount: state.transcript.length,
                                  scrollDirection: .vertical,
                                  itemBuilder: (context, index) => _TranscriptLine(
                                    line: state.transcript[index],
                                    lineIndex: index,
                                    currentIndex: state.index,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          bottom: pu4,
                          child: Builder(
                            builder: (context) {
                              final position = context.select(
                                (PlayerCubit c) => (c.state.position.inMinutes + 1).clamp(1, 5),
                              );
                              return M3EButton.icon(
                                icon: Icon(Icons.auto_awesome),
                                label: Text(locals.getPastNMinutesSummary(position)),
                                style: .tonal,
                                size: .xs,
                                onPressed: () {
                                  final player = context.read<PlayerCubit>();
                                  Past5MinuteSummary.open(
                                    context,
                                    episodeId: player.state.episode?.id ?? '',
                                    language: state.selectedLanguage ?? 'a.i',
                                    time: player.state.position.inSeconds,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _TranscriptLine extends StatelessWidget {
  final int lineIndex;
  final int currentIndex;
  final EpisodeTranscript line;

  const _TranscriptLine({required this.line, required this.lineIndex, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    return Padding(
      padding: .symmetric(vertical: pu2),
      child: SingleMotionBuilder(
        motion: MaterialSpringMotion.expressiveEffectsDefault(),
        from: 0,
        value: currentIndex == lineIndex
            ? 1
            : currentIndex > lineIndex
            ? 0
            : 0.5,
        builder: (context, value, child) => Opacity(
          opacity: value.clamp(0.2, 1),
          child: Text('${line.speaker != null ? '${line.speaker}: ' : ''}${line.content}', style: textTheme.bodyLarge),
        ),
      ),
    );
  }
}
