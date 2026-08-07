// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get podcasts => 'Podcasts';

  @override
  String get episodes => 'Episodes';

  @override
  String get search => 'Search';

  @override
  String get searchPodcasts => 'Search Podcasts';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloadSettings => 'Download settings';

  @override
  String get automaticDownload => 'Download episodes automatically';

  @override
  String automaticDownloadExplanation(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count newest episodes',
      one: 'newest episode',
    );
    return 'Keep the $_temp0, will clear the rest';
  }

  @override
  String get episodesToKeepPerPodcast => 'Episodes per podcast to keep';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get error => 'Error';

  @override
  String get go => 'Go';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get loggingOut => 'Logging out';

  @override
  String get loggingOutText => 'Logging out of the server will delete all the locally downloaded podcast episodes';

  @override
  String get offline => 'Offline';

  @override
  String get play => 'Play';

  @override
  String get markAsPlayed => 'Mark as played';

  @override
  String get download => 'Download';

  @override
  String get addPodcastFromUrl => 'Add podcast from url';

  @override
  String get addPodcast => 'Add podcast';

  @override
  String get next => 'Next';

  @override
  String get podcastUrl => 'Podcast feed URL';

  @override
  String nEpisodes(num count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count episodes', one: '1 episode');
    return '$_temp0';
  }

  @override
  String get podcastAdded => 'Podcast added';

  @override
  String get podcastAddedText => 'Podcast was added successfully';

  @override
  String get back => 'Back';

  @override
  String get podcastParsingError => 'Could not parse podcast';

  @override
  String get importOpml => 'Import OPML file';

  @override
  String get downloadOpml => 'Download OPML file';

  @override
  String get fileDownloaded => 'File downloaded';

  @override
  String get podcastImported => 'Podcasts imported';

  @override
  String get discoverNewPodcasts => 'Discover';

  @override
  String get yourPodcasts => 'Your podcasts';

  @override
  String get yourEpisodes => 'Your episodes';

  @override
  String get openSearch => 'Open full screen search';

  @override
  String get searchForPodcasts => 'Search for new podcasts';

  @override
  String get aiGeneratedTranscript => 'AI generated transcript';
}
