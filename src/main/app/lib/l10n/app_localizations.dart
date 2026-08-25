import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @podcasts.
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get podcasts;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Search Podcasts'**
  String get searchPodcasts;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get unsubscribe;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @downloadSettings.
  ///
  /// In en, this message translates to:
  /// **'Download settings'**
  String get downloadSettings;

  /// No description provided for @automaticDownload.
  ///
  /// In en, this message translates to:
  /// **'Download episodes automatically'**
  String get automaticDownload;

  /// No description provided for @automaticDownloadExplanation.
  ///
  /// In en, this message translates to:
  /// **'Keep the {count, plural, =1{newest episode} other{{count} newest episodes}}, will clear the rest'**
  String automaticDownloadExplanation(num count);

  /// No description provided for @episodesToKeepPerPodcast.
  ///
  /// In en, this message translates to:
  /// **'Episodes per podcast to keep'**
  String get episodesToKeepPerPodcast;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out'**
  String get loggingOut;

  /// No description provided for @loggingOutText.
  ///
  /// In en, this message translates to:
  /// **'Logging out of the server will delete all the locally downloaded podcast episodes'**
  String get loggingOutText;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @markAsPlayed.
  ///
  /// In en, this message translates to:
  /// **'Mark as played'**
  String get markAsPlayed;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @addPodcastFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Add podcast from url'**
  String get addPodcastFromUrl;

  /// No description provided for @addPodcast.
  ///
  /// In en, this message translates to:
  /// **'Add podcast'**
  String get addPodcast;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @podcastUrl.
  ///
  /// In en, this message translates to:
  /// **'Podcast feed URL'**
  String get podcastUrl;

  /// No description provided for @nEpisodes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 episode} other{{count} episodes}}'**
  String nEpisodes(num count);

  /// No description provided for @podcastAdded.
  ///
  /// In en, this message translates to:
  /// **'Podcast added'**
  String get podcastAdded;

  /// No description provided for @podcastAddedText.
  ///
  /// In en, this message translates to:
  /// **'Podcast was added successfully'**
  String get podcastAddedText;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @podcastParsingError.
  ///
  /// In en, this message translates to:
  /// **'Could not parse podcast'**
  String get podcastParsingError;

  /// No description provided for @importOpml.
  ///
  /// In en, this message translates to:
  /// **'Import OPML file'**
  String get importOpml;

  /// No description provided for @downloadOpml.
  ///
  /// In en, this message translates to:
  /// **'Download OPML file'**
  String get downloadOpml;

  /// No description provided for @fileDownloaded.
  ///
  /// In en, this message translates to:
  /// **'File downloaded'**
  String get fileDownloaded;

  /// No description provided for @podcastImported.
  ///
  /// In en, this message translates to:
  /// **'Podcasts imported'**
  String get podcastImported;

  /// No description provided for @discoverNewPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverNewPodcasts;

  /// No description provided for @yourPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Your podcasts'**
  String get yourPodcasts;

  /// No description provided for @yourEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Your episodes'**
  String get yourEpisodes;

  /// No description provided for @openSearch.
  ///
  /// In en, this message translates to:
  /// **'Open full screen search'**
  String get openSearch;

  /// No description provided for @searchForPodcasts.
  ///
  /// In en, this message translates to:
  /// **'Search for new podcasts'**
  String get searchForPodcasts;

  /// No description provided for @aiGeneratedTranscript.
  ///
  /// In en, this message translates to:
  /// **'AI generated transcript'**
  String get aiGeneratedTranscript;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Connected devices'**
  String get devices;

  /// No description provided for @thisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get thisDevice;

  /// No description provided for @devicesExplanation.
  ///
  /// In en, this message translates to:
  /// **'Select which device should be playing audio'**
  String get devicesExplanation;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @fromTranscript.
  ///
  /// In en, this message translates to:
  /// **'From transcript'**
  String get fromTranscript;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark saved'**
  String get bookmarkAdded;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get addBookmark;

  /// No description provided for @deleteBookmark.
  ///
  /// In en, this message translates to:
  /// **'Delete bookmark?'**
  String get deleteBookmark;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get cannotBeUndone;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks, tap '**
  String get noBookmarks;

  /// No description provided for @noBookmarksEnd.
  ///
  /// In en, this message translates to:
  /// **'when playing a podcast.'**
  String get noBookmarksEnd;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
