import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/bottom_sheets/m3e_bottom_sheets.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/components/dialogs/m3e_dialogs.dart';
import 'package:material_3_expressive/foundations/m3e_icons.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/player/views/components/remote_player.dart';
import 'package:podku/server/states/server.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/models/breakpoint.dart';
import 'package:podku/utils/views/components/bottom_sheet_title.dart';

class RemotePlayers extends StatelessWidget {
  const RemotePlayers({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;
    return Builder(
      builder: (context) {
        final clients = context.select((ServerCubit c) => c.state.clients);
        final playingLocally = context.select((PlayerCubit c) => c.isPlayingLocally);
        final currentPlayer = context.select((PlayerCubit c) => c.state.currentPlayer);
        if (clients.length > 1) {
          return M3EButton.icon(
            style: .text,
            label: Text(!playingLocally ? currentPlayer?.name ?? '' : ''),
            onPressed: () => RemotePlayersDialog.open(context),
            icon: Icon(
              playingLocally ? M3EIcons.devices : M3EIcons.tap_and_play,
              color: playingLocally ? null : colors.primary,
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

class RemotePlayersDialog extends StatelessWidget {
  final bool showTitle;

  const RemotePlayersDialog({super.key, required this.showTitle});

  static Future<Object?> open(BuildContext context) async {
    final isMobile = BreakPoint.of(context) == .mobile;

    final locals = AppLocalizations.of(context)!;

    return isMobile
        ? M3EBottomSheet.show(
            context,
            showDragHandle: false,
            builder: (context) => SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
                child: RemotePlayersDialog(showTitle: true),
              ),
            ),
          )
        : M3EDialog.show(
            context,
            dialog: M3EDialog(
              // backgroundColor: Colors.transparent,
              // constraints: BoxConstraints(maxWidth: 400, maxHeight: 700),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
                child: RemotePlayersDialog(showTitle: false),
              ),
              title: locals.devices,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;

    return Builder(
      builder: (context) {
        final clients = context.select((ServerCubit c) => c.state.clients);
        final currentPlayer = context.select((PlayerCubit c) => c.state.currentPlayer);
        return Padding(
          padding: .symmetric(vertical: pu2, horizontal: pu6),
          child: Column(
            spacing: pu,
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              if (showTitle) BottomSheetTitle(title: locals.devices, icon: Icon(M3EIcons.devices_other)),
              Text(locals.devicesExplanation),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: clients.length,
                  itemBuilder: (context, index) =>
                      RemotePlayer(player: clients[index], isCurrent: currentPlayer?.id == clients[index].id),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
