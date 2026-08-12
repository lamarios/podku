import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/menus/m3e_menus.dart';
import 'package:podku/player/states/player.dart';

const List<double> availableSpeeds = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 3, 4, 5, 6];

class PlayerSpeed extends StatelessWidget {
  const PlayerSpeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final speed = context.select((PlayerCubit c) => c.state.speed);
        return M3EMenu(
          anchorBuilder: (context, open) {
            return Row(
              children: [TextButton.icon(onPressed: () => open(), label: Text('${speed}x'), icon: Icon(Icons.speed))],
            );
          },
          children: availableSpeeds
              .map(
                (speed) =>
                    (M3EMenuEntry(onPressed: () => context.read<PlayerCubit>().setSpeed(speed), label: '${speed}x')),
              )
              .toList(),
        );
      },
    );
  }
}
