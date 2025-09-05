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
  /// In zh, this message translates to:
  /// **'网站克隆器'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In zh, this message translates to:
  /// **'网站克隆器'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'克隆网站、截图并生成目录索引'**
  String get homeSubtitle;

  /// No description provided for @menuAccount.
  ///
  /// In zh, this message translates to:
  /// **'账号管理'**
  String get menuAccount;

  /// No description provided for @menuAccountDesc.
  ///
  /// In zh, this message translates to:
  /// **'管理你的账号和凭据'**
  String get menuAccountDesc;

  /// No description provided for @menuTask.
  ///
  /// In zh, this message translates to:
  /// **'任务管理'**
  String get menuTask;

  /// No description provided for @menuTaskDesc.
  ///
  /// In zh, this message translates to:
  /// **'创建和管理克隆任务'**
  String get menuTaskDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @outputDir.
  ///
  /// In zh, this message translates to:
  /// **'输出目录'**
  String get outputDir;

  /// No description provided for @chooseDir.
  ///
  /// In zh, this message translates to:
  /// **'选择目录'**
  String get chooseDir;

  /// No description provided for @saved.
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get saved;

  /// No description provided for @outputDirUpdated.
  ///
  /// In zh, this message translates to:
  /// **'输出目录已更新'**
  String get outputDirUpdated;

  /// No description provided for @accountPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'账号管理'**
  String get accountPageTitle;

  /// No description provided for @accountName.
  ///
  /// In zh, this message translates to:
  /// **'账号名称'**
  String get accountName;

  /// No description provided for @totalAccounts.
  ///
  /// In zh, this message translates to:
  /// **'账号总数：{count}'**
  String totalAccounts(Object count);

  /// No description provided for @addAccount.
  ///
  /// In zh, this message translates to:
  /// **'新增账号'**
  String get addAccount;

  /// No description provided for @noAccounts.
  ///
  /// In zh, this message translates to:
  /// **'暂无账号'**
  String get noAccounts;

  /// No description provided for @addAccountHint.
  ///
  /// In zh, this message translates to:
  /// **'点击“新增账号”创建你的第一个账号'**
  String get addAccountHint;

  /// No description provided for @urlLabel.
  ///
  /// In zh, this message translates to:
  /// **'地址：{url}'**
  String urlLabel(Object url);

  /// No description provided for @loggedIn.
  ///
  /// In zh, this message translates to:
  /// **'已登录'**
  String get loggedIn;

  /// No description provided for @notLoggedIn.
  ///
  /// In zh, this message translates to:
  /// **'未登录'**
  String get notLoggedIn;

  /// No description provided for @loginAndSaveCookies.
  ///
  /// In zh, this message translates to:
  /// **'登录并保存Cookies'**
  String get loginAndSaveCookies;

  /// No description provided for @taskPageTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务管理'**
  String get taskPageTitle;

  /// No description provided for @totalTasks.
  ///
  /// In zh, this message translates to:
  /// **'任务总数：{count}'**
  String totalTasks(Object count);

  /// No description provided for @createTask.
  ///
  /// In zh, this message translates to:
  /// **'创建任务'**
  String get createTask;

  /// No description provided for @noTasks.
  ///
  /// In zh, this message translates to:
  /// **'暂无任务'**
  String get noTasks;

  /// No description provided for @createTaskHint.
  ///
  /// In zh, this message translates to:
  /// **'点击“创建任务”开始你的第一个克隆任务'**
  String get createTaskHint;

  /// No description provided for @taskName.
  ///
  /// In zh, this message translates to:
  /// **'任务名称'**
  String get taskName;

  /// No description provided for @websiteUrl.
  ///
  /// In zh, this message translates to:
  /// **'网站地址'**
  String get websiteUrl;

  /// No description provided for @urlInvalid.
  ///
  /// In zh, this message translates to:
  /// **'请输入合法的网址'**
  String get urlInvalid;

  /// No description provided for @urlRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入网站地址'**
  String get urlRequired;

  /// No description provided for @taskNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入任务名称'**
  String get taskNameRequired;

  /// No description provided for @urlPattern.
  ///
  /// In zh, this message translates to:
  /// **'爬取的URL 规则（* 为通配符）'**
  String get urlPattern;

  /// No description provided for @allowedDomains.
  ///
  /// In zh, this message translates to:
  /// **'允许的域名'**
  String get allowedDomains;

  /// No description provided for @addDomainHint.
  ///
  /// In zh, this message translates to:
  /// **'输入域名后回车添加'**
  String get addDomainHint;

  /// No description provided for @maxPages.
  ///
  /// In zh, this message translates to:
  /// **'最大页面数'**
  String get maxPages;

  /// No description provided for @accountForCookies.
  ///
  /// In zh, this message translates to:
  /// **'账号（用于Cookies）'**
  String get accountForCookies;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get create;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @captureUrlPattern.
  ///
  /// In zh, this message translates to:
  /// **'截图URL规则（* 为通配符）'**
  String get captureUrlPattern;

  /// No description provided for @captureUrlPatternHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：*.html 或留空捕获所有'**
  String get captureUrlPatternHint;

  /// No description provided for @ignoreUrlPatterns.
  ///
  /// In zh, this message translates to:
  /// **'忽略的URL规则(*为通配符)'**
  String get ignoreUrlPatterns;

  /// No description provided for @addPatternHint.
  ///
  /// In zh, this message translates to:
  /// **'输入规则后回车添加'**
  String get addPatternHint;

  /// No description provided for @maxConcurrentTasks.
  ///
  /// In zh, this message translates to:
  /// **'最大并发任务数'**
  String get maxConcurrentTasks;

  /// No description provided for @maxConcurrentTasksHint.
  ///
  /// In zh, this message translates to:
  /// **'留空默认'**
  String get maxConcurrentTasksHint;

  /// No description provided for @maxPagesHint.
  ///
  /// In zh, this message translates to:
  /// **'留空表示不限制'**
  String get maxPagesHint;

  /// No description provided for @progress.
  ///
  /// In zh, this message translates to:
  /// **'进度：{visited}/{total} ({percent}%)'**
  String progress(Object percent, Object total, Object visited);

  /// No description provided for @editAccount.
  ///
  /// In zh, this message translates to:
  /// **'账号修改'**
  String get editAccount;

  /// No description provided for @deleteTask.
  ///
  /// In zh, this message translates to:
  /// **'删除任务'**
  String get deleteTask;

  /// No description provided for @areYouSureYouWantToDelete.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除“{name}”吗？'**
  String areYouSureYouWantToDelete(Object name);

  /// No description provided for @accountNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入账号名称'**
  String get accountNameRequired;

  /// No description provided for @editTask.
  ///
  /// In zh, this message translates to:
  /// **'任务修改'**
  String get editTask;

  /// No description provided for @deleteAccount.
  ///
  /// In zh, this message translates to:
  /// **'删除账号'**
  String get deleteAccount;

  /// No description provided for @logs.
  ///
  /// In zh, this message translates to:
  /// **'日志'**
  String get logs;

  /// No description provided for @loginProcess.
  ///
  /// In zh, this message translates to:
  /// **'登录过程'**
  String get loginProcess;

  /// No description provided for @loginProcessHint.
  ///
  /// In zh, this message translates to:
  /// **'一个浏览器窗口已经打开。请完成登录过程，然后点击“保存”捕获Cookies。'**
  String get loginProcessHint;

  /// No description provided for @saveCookies.
  ///
  /// In zh, this message translates to:
  /// **'保存Cookies'**
  String get saveCookies;

  /// No description provided for @error.
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get error;

  /// No description provided for @failedToOpenBrowserOrSaveCookies.
  ///
  /// In zh, this message translates to:
  /// **'打开浏览器或保存Cookies失败：{error}'**
  String failedToOpenBrowserOrSaveCookies(Object error);

  /// No description provided for @cookiesSavedSuccessfully.
  ///
  /// In zh, this message translates to:
  /// **'Cookies保存成功！'**
  String get cookiesSavedSuccessfully;

  /// No description provided for @noCookiesWereCaptured.
  ///
  /// In zh, this message translates to:
  /// **'没有捕获到Cookies。'**
  String get noCookiesWereCaptured;

  /// No description provided for @warning.
  ///
  /// In zh, this message translates to:
  /// **'警告'**
  String get warning;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @none.
  ///
  /// In zh, this message translates to:
  /// **'无'**
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
