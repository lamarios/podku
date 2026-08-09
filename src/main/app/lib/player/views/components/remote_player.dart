import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/lists/m3e_lists.dart';
import 'package:material_3_expressive/foundations/m3e_icons.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/main.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';
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
        onTap: () => context.read<PlayerCubit>().initialPlaybackTransfer(player.id),
        headline: player.id == sessionId ? locals.thisDevice : player.name,
        selected: isCurrent,
        leading: Icon(isCurrent ? M3EIcons.music_note : M3EIcons.devices, color: isCurrent ? colors.primary : null),
      ),
    );
  }
}
