import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Web Cloner'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Web Cloner'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clone websites, capture screenshots, and generate directories'**
  String get homeSubtitle;

  /// No description provided for @menuAccount.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get menuAccount;

  /// No description provided for @menuAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your accounts and credentials'**
  String get menuAccountDesc;

  /// No description provided for @menuTask.
  ///
  /// In en, this message translates to:
  /// **'Task Management'**
  String get menuTask;

  /// No description provided for @menuTaskDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and manage cloning tasks'**
  String get menuTaskDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @outputDir.
  ///
  /// In en, this message translates to:
  /// **'Output Directory'**
  String get outputDir;

  /// No description provided for @chooseDir.
  ///
  /// In en, this message translates to:
  /// **'Choose directory'**
  String get chooseDir;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @outputDirUpdated.
  ///
  /// In en, this message translates to:
  /// **'Output directory updated'**
  String get outputDirUpdated;

  /// No description provided for @accountPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountPageTitle;

  /// No description provided for @totalAccounts.
  ///
  /// In en, this message translates to:
  /// **'Total Accounts: {count}'**
  String totalAccounts(Object count);

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account Name'**
  String get accountName;

  /// No description provided for @accountNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter account name'**
  String get accountNameRequired;

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts found'**
  String get noAccounts;

  /// No description provided for @addAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Click \"Add Account\" to create your first account'**
  String get addAccountHint;

  /// No description provided for @urlLabel.
  ///
  /// In en, this message translates to:
  /// **'URL: {url}'**
  String urlLabel(Object url);

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged In'**
  String get loggedIn;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not Logged In'**
  String get notLoggedIn;

  /// No description provided for @loginAndSaveCookies.
  ///
  /// In en, this message translates to:
  /// **'Login and save cookies'**
  String get loginAndSaveCookies;

  /// No description provided for @taskPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Management'**
  String get taskPageTitle;

  /// No description provided for @totalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks: {count}'**
  String totalTasks(Object count);

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get noTasks;

  /// No description provided for @createTaskHint.
  ///
  /// In en, this message translates to:
  /// **'Click \"Create Task\" to start your first cloning task'**
  String get createTaskHint;

  /// No description provided for @taskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get taskName;

  /// No description provided for @websiteUrl.
  ///
  /// In en, this message translates to:
  /// **'Website URL'**
  String get websiteUrl;

  /// No description provided for @urlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get urlInvalid;

  /// No description provided for @urlRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter website URL'**
  String get urlRequired;

  /// No description provided for @taskNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter task name'**
  String get taskNameRequired;

  /// No description provided for @urlPattern.
  ///
  /// In en, this message translates to:
  /// **'URL Pattern (use * as wildcard)'**
  String get urlPattern;

  /// No description provided for @allowedDomains.
  ///
  /// In en, this message translates to:
  /// **'Allowed Domains'**
  String get allowedDomains;

  /// No description provided for @addDomainHint.
  ///
  /// In en, this message translates to:
  /// **'Add a domain and press Enter'**
  String get addDomainHint;

  /// No description provided for @maxPages.
  ///
  /// In en, this message translates to:
  /// **'Max Pages'**
  String get maxPages;

  /// No description provided for @accountForCookies.
  ///
  /// In en, this message translates to:
  /// **'Account (for cookies)'**
  String get accountForCookies;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress: {visited}/{total} ({percent}%)'**
  String progress(Object percent, Object total, Object visited);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @captureUrlPattern.
  ///
  /// In en, this message translates to:
  /// **'Capture URL Pattern (use * as wildcard)'**
  String get captureUrlPattern;

  /// No description provided for @captureUrlPatternHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., *.html or leave empty to capture all'**
  String get captureUrlPatternHint;

  /// No description provided for @ignoreUrlPatterns.
  ///
  /// In en, this message translates to:
  /// **'Ignore URL Patterns'**
  String get ignoreUrlPatterns;

  /// No description provided for @addPatternHint.
  ///
  /// In en, this message translates to:
  /// **'Add a pattern and press Enter'**
  String get addPatternHint;

  /// No description provided for @maxConcurrentTasks.
  ///
  /// In en, this message translates to:
  /// **'Max Concurrent Tasks'**
  String get maxConcurrentTasks;

  /// No description provided for @maxConcurrentTasksHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for default'**
  String get maxConcurrentTasksHint;

  /// No description provided for @maxPagesHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for default'**
  String get maxPagesHint;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
