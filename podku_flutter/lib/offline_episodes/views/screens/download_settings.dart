import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podku/offline_episodes/states/download_settings.dart';
import 'package:podku/utils/views/components/int_stepper.dart';

class DownloadSettingsScreen extends StatelessWidget {
  const DownloadSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download settings'),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocProvider(
          create: (context) => DownloadSettingsCubit(DownloadSettingsState()),
          child: BlocBuilder<DownloadSettingsCubit, DownloadSettingsState>(
            builder: (context, state) {
              final cubit = context.read<DownloadSettingsCubit>();
              return Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .stretch,
                children: [
                  SwitchListTile.adaptive(
                    dense: true,
                    visualDensity: .compact,
                    title: Text('Download podcast episodes automatically'),
                    subtitle: Text(
                      'Keep the ${state.podcastEpisodes} newest episodes for each podcast, will clear the rest.',
                    ),
                    value: state.downloadAutomatically,
                    onChanged: (value) => cubit.setDownloadAutomatically(value),
                  ),
                  ListTile(
                    enabled: state.downloadAutomatically,
                    title: Text('Episodes per podcast to keep'),
                    trailing: IntStepper(
                      enabled: state.downloadAutomatically,
                      value: state.podcastEpisodes,
                      onChanged: (value) => cubit.setPodcastEpisodes(value),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
