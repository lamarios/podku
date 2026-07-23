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
  String get unsubscribe => 'Unsubscribed';

  @override
  String get downloads => 'Downloads';

  @override
  String get downloadSettings => 'Download settings';

  @override
  String get automaticDownload => 'Download podcasts episodes automatically';

  @override
  String automaticDownloadExplanation(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count newest episodes',
      one: 'newest episode',
    );
    return 'Keep the $_temp0 for each podcast, will clear the rest';
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
}
