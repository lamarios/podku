import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'download_settings.freezed.dart';

class DownloadSettingsCubit extends Cubit<DownloadSettingsState> {
  static const downloadAutomaticallyKey = 'downloadAutomatic';
  static const podcastEpisodesKey = 'podcastEpisodes';

  DownloadSettingsCubit(super.initialState) {
    init();
  }

  Future<void> init() async {
    emit(
      state.copyWith(
        downloadAutomatically: await downloadAutomatically,
        podcastEpisodes: await podcastEpisodes,
      ),
    );
  }

  static Future<bool> get downloadAutomatically async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(downloadAutomaticallyKey) ?? false;
  }

  static Future<int> get podcastEpisodes async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(podcastEpisodesKey) ?? 1;
  }

  Future<void> setDownloadAutomatically(bool value) async {
    emit(state.copyWith(downloadAutomatically: value));
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(downloadAutomaticallyKey, value);
  }

  Future<void> setPodcastEpisodes(int episodes) async {
    emit(state.copyWith(podcastEpisodes: episodes));
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(podcastEpisodesKey, episodes);
  }
}

@freezed
sealed class DownloadSettingsState with _$DownloadSettingsState {
  const factory DownloadSettingsState({
    @Default(false) bool downloadAutomatically,
    @Default(2) int podcastEpisodes,
  }) = _DownloadSettingsState;
}
