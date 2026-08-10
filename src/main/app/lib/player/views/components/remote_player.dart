import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/components/lists/m3e_lists.dart';
import 'package:material_3_expressive/foundations/m3e_icons.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/conditional_wrap.dart';
import 'package:podku_shared/podku_shared.dart';

class RemotePlayer extends StatelessWidget {
  final PlayerInfo player;
  final bool isCurrent;

  const RemotePlayer({super.key, required this.player, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locals = AppLocalizations.of(context)!;
    return Padding(
      padding: .only(bottom: pu2),
      child: M3EListItem(
        onTap: () {
          context.read<PlayerCubit>().initialPlaybackTransfer(player.id);
          context.pop();
        },
        headline: player.id == sessionId ? locals.thisDevice : player.name,
        selected: isCurrent,
        leading: ConditionalWrap(
          wrapIf: isCurrent,
          wrapper: (child) => Stack(
            clipBehavior: .none,
            children: [
              _DisappearingNote(endOffset: Offset(0.2, -0.7)),
              _DisappearingNote(endOffset: Offset(-0.1, -0.6), delay: Duration(milliseconds: 500)),
              _DisappearingNote(endOffset: Offset(0.7, -0.8), delay: Duration(milliseconds: 2432)),
              child,
            ],
          ),
          child: Icon(isCurrent ? M3EIcons.music_note : M3EIcons.devices, color: isCurrent ? colors.primary : null),
        ),
      ),
    );
  }
}

class _DisappearingNote extends StatelessWidget {
  final Offset endOffset;
  final Duration delay;

  const _DisappearingNote({required this.endOffset, this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    return Icon(M3EIcons.music_note, color: colors.primary.withValues(alpha: 0.5))
        .animate(
          onPlay: (controller) => controller.repeat(), // loop
        )
        .slide(delay: delay, begin: Offset.zero, end: endOffset, duration: Duration(seconds: 1))
        .fadeOut(delay: delay);
  }
}
