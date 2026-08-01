import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_3_expressive/components/app_bars/m3e_app_bars.dart';
import 'package:material_3_expressive/components/lists/m3e_lists.dart';
import 'package:material_3_expressive/components/switch_control/m3e_switch_control.dart';
import 'package:podku/l10n/app_localizations.dart';
import 'package:podku/offline_episodes/states/download_settings.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/int_stepper.dart';

class DownloadSettingsScreen extends StatelessWidget {
  const DownloadSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: M3EAppBar.top(
        title: Text(locals.downloadSettings),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        bottom: false,
        child: BlocProvider(
          create: (context) => DownloadSettingsCubit(DownloadSettingsState()),
          child: BlocBuilder<DownloadSettingsCubit, DownloadSettingsState>(
            builder: (context, state) {
              final cubit = context.read<DownloadSettingsCubit>();
              return Padding(
                padding: .all(pu2),
                child: Column(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .stretch,
                  children: [
                    M3EListItem(
                      headline: locals.automaticDownload,
                      leading: Icon(Icons.download),
                      selected: state.downloadAutomatically,
                      supportingText: locals.automaticDownloadExplanation(state.podcastEpisodes),
                      trailing: M3ESwitch(
                        value: state.downloadAutomatically,
                        onChanged: (value) => cubit.setDownloadAutomatically(value),
                      ),
                      onTap: () => cubit.setDownloadAutomatically(!state.downloadAutomatically),
                    ),
                    ListTile(
                      enabled: state.downloadAutomatically,
                      title: Text(locals.episodesToKeepPerPodcast),
                      trailing: IntStepper(
                        enabled: state.downloadAutomatically,
                        value: state.podcastEpisodes,
                        onChanged: (value) => cubit.setPodcastEpisodes(value),
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
