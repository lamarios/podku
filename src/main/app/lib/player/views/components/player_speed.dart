import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/player/states/audio_handler.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku/utils.dart';

const List<double> availableSpeeds = [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2, 3, 4, 5, 6];

class PlayerSpeed extends StatelessWidget {
  const PlayerSpeed({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return Row(
          children: [
            TextButton.icon(
              onPressed: () => controller.isOpen ? controller.close() : controller.open(),
              label: StreamBuilder(
                stream: getIt.get<PodkuAudioHandler>().playbackState.stream.map((event) => event.speed),
                builder: (context, snapshot) => Text('${snapshot.data ?? 1}x'),
              ),
              icon: Icon(Icons.speed),
            ),
          ],
        );
      },
      menuChildren: availableSpeeds
          .map(
            (speed) => (MenuItemButton(
              onPressed: () => context.read<PlayerCubit>().setSpeed(speed),
              child: Text('${speed}x'),
            )),
          )
          .toList(),
    );
  }
}
