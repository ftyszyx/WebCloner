// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '网站克隆器';

  @override
  String get homeTitle => '网站克隆器';

  @override
  String get homeSubtitle => '克隆网站、截图并生成目录索引';

  @override
  String get menuAccount => '账号管理';

  @override
  String get menuAccountDesc => 'Manage your accounts and credentials';

  @override
  String get menuTask => '任务管理';

  @override
  String get menuTaskDesc => 'Create and manage cloning tasks';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get outputDir => '输出目录';

  @override
  String get chooseDir => '选择目录';

  @override
  String get saved => '已保存';

  @override
  String get outputDirUpdated => '输出目录已更新';

  @override
  String get accountPageTitle => '账号管理';

  @override
  String totalAccounts(Object count) {
    return '账号总数：$count';
  }

  @override
  String get addAccount => '新增账号';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get accountName => 'Account Name';

  @override
  String get accountNameRequired => 'Please enter account name';

  @override
  String get noAccounts => '暂无账号';

  @override
  String get addAccountHint => '点击“新增账号”创建你的第一个账号';

  @override
  String urlLabel(Object url) {
    return '地址：$url';
  }

  @override
  String get loggedIn => '已登录';

  @override
  String get notLoggedIn => '未登录';

  @override
  String get loginAndSaveCookies => '登录并保存Cookies';

  @override
  String get taskPageTitle => '任务管理';

  @override
  String totalTasks(Object count) {
    return '任务总数：$count';
  }

  @override
  String get createTask => '创建任务';

  @override
  String get editTask => 'Edit Task';

  @override
  String get noTasks => '暂无任务';

  @override
  String get createTaskHint => '点击“创建任务”开始你的第一个克隆任务';

  @override
  String get taskName => '任务名称';

  @override
  String get websiteUrl => '网站地址';

  @override
  String get urlInvalid => '请输入合法的网址';

  @override
  String get urlRequired => '请输入网站地址';

  @override
  String get taskNameRequired => '请输入任务名称';

  @override
  String get urlPattern => 'URL 规则（* 为通配符）';

  @override
  String get allowedDomains => '允许的域名';

  @override
  String get addDomainHint => '输入域名后回车添加';

  @override
  String get maxPages => '最大页面数';

  @override
  String get accountForCookies => '账号（用于Cookies）';

  @override
  String progress(Object percent, Object total, Object visited) {
    return 'Progress: $visited/$total ($percent%)';
  }

  @override
  String get cancel => '取消';

  @override
  String get create => '创建';

  @override
  String get save => '保存';
}
