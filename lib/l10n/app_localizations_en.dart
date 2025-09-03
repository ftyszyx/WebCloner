// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Web Cloner';

  @override
  String get homeTitle => 'Web Cloner';

  @override
  String get homeSubtitle =>
      'Clone websites, capture screenshots, and generate directories';

  @override
  String get menuAccount => 'Account Management';

  @override
  String get menuAccountDesc => 'Manage your accounts and credentials';

  @override
  String get menuTask => 'Task Management';

  @override
  String get menuTaskDesc => 'Create and manage cloning tasks';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get outputDir => 'Output Directory';

  @override
  String get chooseDir => 'Choose directory';

  @override
  String get saved => 'Saved';

  @override
  String get outputDirUpdated => 'Output directory updated';

  @override
  String get accountPageTitle => 'Account Management';

  @override
  String totalAccounts(Object count) {
    return 'Total Accounts: $count';
  }

  @override
  String get addAccount => 'Add Account';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountNameRequired => 'Please enter account name';

  @override
  String get noAccounts => 'No accounts found';

  @override
  String get addAccountHint =>
      'Click \"Add Account\" to create your first account';

  @override
  String urlLabel(Object url) {
    return 'URL: $url';
  }

  @override
  String get loggedIn => 'Logged In';

  @override
  String get notLoggedIn => 'Not Logged In';

  @override
  String get loginAndSaveCookies => 'Login and save cookies';

  @override
  String get taskPageTitle => 'Task Management';

  @override
  String totalTasks(Object count) {
    return 'Total Tasks: $count';
  }

  @override
  String get createTask => 'Create Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get noTasks => 'No tasks found';

  @override
  String get createTaskHint =>
      'Click \"Create Task\" to start your first cloning task';

  @override
  String get taskName => 'Task Name';

  @override
  String get websiteUrl => 'Website URL';

  @override
  String get urlInvalid => 'Please enter a valid URL';

  @override
  String get urlRequired => 'Please enter website URL';

  @override
  String get taskNameRequired => 'Please enter task name';

  @override
  String get urlPattern => 'URL Pattern (use * as wildcard)';

  @override
  String get allowedDomains => 'Allowed Domains';

  @override
  String get addDomainHint => 'Add a domain and press Enter';

  @override
  String get maxPages => 'Max Pages';

  @override
  String get accountForCookies => 'Account (for cookies)';

  @override
  String progress(Object percent, Object total, Object visited) {
    return 'Progress: $visited/$total ($percent%)';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';
}
