import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/player/states/player.dart';
import 'package:podku_client/podku_client.dart';

class TimestampLink extends StatelessWidget {
  final String timestamp;
  final Episode episode;
  final bool offline;

  const TimestampLink({super.key, required this.timestamp, required this.episode, required this.offline});

  Future<void> _seekOrPlay(BuildContext context) async {
    final split = timestamp.split(":").map((e) => int.parse(e)).toList();
    final duration = Duration(hours: split[0], minutes: split[1], seconds: split[2]);

    final cubit = context.read<PlayerCubit>();
    if (cubit.state.episode?.id == episode.id && cubit.state.playing) {
      cubit.seek(duration);
    } else {
      cubit.playEpisode(episode, initialPosition: duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _seekOrPlay(context),
      child: Text(timestamp, style: textTheme.bodyMedium?.copyWith(color: colors.primary)),
    );
  }
}
