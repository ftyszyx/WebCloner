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
  String get accountName => 'Account Name';

  @override
  String totalAccounts(Object count) {
    return 'Total Accounts: $count';
  }

  @override
  String get addAccount => 'Add Account';

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
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get save => 'Save';

  @override
  String get captureUrlPattern => 'Capture URL Pattern (use * as wildcard)';

  @override
  String get captureUrlPatternHint =>
      'e.g., *.html or leave empty to capture all';

  @override
  String get ignoreUrlPatterns => 'Ignore URL Patterns';

  @override
  String get addPatternHint => 'Add a pattern and press Enter';

  @override
  String get maxConcurrentTasks => 'Max Concurrent Tasks';

  @override
  String get maxConcurrentTasksHint => 'Leave empty for default';

  @override
  String get maxPagesHint => 'Leave empty for default';

  @override
  String progress(Object percent, Object total, Object visited) {
    return 'Progress: $visited/$total ($percent%)';
  }

  @override
  String get editAccount => 'Edit Account';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String areYouSureYouWantToDelete(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get accountNameRequired => 'Please enter account name';

  @override
  String get editTask => 'Edit Task';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get logs => 'Logs';

  @override
  String get loginProcess => '登录过程';

  @override
  String get loginProcessHint => '一个浏览器窗口已经打开。请完成登录过程，然后点击“保存”捕获Cookies。';

  @override
  String get saveCookies => '保存Cookies';

  @override
  String get error => 'Error';

  @override
  String failedToOpenBrowserOrSaveCookies(Object error) {
    return 'Failed to open browser or save cookies: $error';
  }

  @override
  String get cookiesSavedSuccessfully => 'Cookies saved successfully!';

  @override
  String get noCookiesWereCaptured => 'No cookies were captured.';

  @override
  String get warning => 'Warning';

  @override
  String get delete => '删除';

  @override
  String get none => 'None';
}
