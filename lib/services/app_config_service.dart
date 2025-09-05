import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_cloner/modules/core/const.dart';
import 'logger.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:yaml/yaml.dart';

class AppConfigService extends GetxService {
  String appTitle = "";
  String chromeAssetUrl = "";
  String ffmpegAssetUrl = "";

  LogLevel _logLevel = LogLevel.info;
  LogLevel get logLevel => _logLevel;

  late String _appDataPath;
  String get appDataPath => _appDataPath;

  late String _appCachePath;
  String get appCachePath => _appCachePath;

  late String _appConfigPath;
  String get appConfigPath => _appConfigPath;

  String get chromeDir => path.join(_appDataPath, GlobalConst.chromeDir);

  String get chromeDataPath => path.join(_appDataPath, 'chrome-data');
  String get outputDir =>
      _config['outputDir'] ?? path.join(_appDataPath, 'output');

  final String _userAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36";
  String get userAgent => _userAgent;

  bool _isdebug = false;
  bool get isdebug => _isdebug;

  Map<String, dynamic> _config = {};
  Map<String, dynamic> get config => _config;

  static AppConfigService get instance => Get.find<AppConfigService>();
  Future init() async {
    String appConfigContent = '';
    try {
      // Prefer loading from Flutter assets (works in release bundles)
      appConfigContent = await rootBundle.loadString('assets/app_config.yaml');
      final appConfigMap = loadYaml(appConfigContent);
      appTitle = appConfigMap['app_title'];
      chromeAssetUrl = appConfigMap['chrome_asset_url'];
      ffmpegAssetUrl = appConfigMap['ffmpeg_asset_url'];
    } catch (_) {
      throw Exception('Cannot find assets/app_config.yaml in assets bundle');
    }
    _appDataPath = (await getApplicationSupportDirectory()).path;
    _appCachePath = (await getApplicationCacheDirectory()).path;
    final appConfigPath = path.join(_appDataPath, 'config.json');
    _appConfigPath = appConfigPath;
    _isdebug = false;
    if (File(appConfigPath).existsSync()) {
      _config = json.decode(File(appConfigPath).readAsStringSync());
      _logLevel = LogLevel.values.firstWhere(
        (e) => e.name == _config['logLevel'],
        orElse: () => LogLevel.info,
      );
      _isdebug = _config['isdebug'] ?? false;
    } else {
      _config = {
        'logLevel': _logLevel.name,
        'isdebug': _isdebug,
        'locale': 'zh',
        // outputDir omitted -> falls back to appData/output
      };
      File(appConfigPath).createSync(recursive: true);
      File(appConfigPath).writeAsStringSync(json.encode(_config));
    }
    await initChromeDataPath();
    if (!Directory(outputDir).existsSync()) {
      Directory(outputDir).createSync(recursive: true);
    }
  }

  void setLogLevel(LogLevel level) {
    setValue('logLevel', level.name);
  }

  LogLevel getLogLevel() {
    return LogLevel.values.firstWhere(
      (e) => e.name == getValue('logLevel', _logLevel.name),
      orElse: () => _logLevel,
    );
  }

  Locale getLocale() {
    return Locale(getLocaleStr());
  }

  String getLocaleStr() {
    //get from system
    final locale = Platform.localeName;
    var defaultLocale = 'zh';
    if (locale.contains('zh') == false) {
      defaultLocale = 'en';
    }
    return getValue('locale', defaultLocale);
  }

  void setLocale(String locale) {
    setValue('locale', locale);
  }

  void setOutputDir(String dir) {
    setValue('outputDir', dir);
    if (!Directory(dir).existsSync()) {
      Directory(dir).createSync(recursive: true);
    }
  }

  T getValue<T>(dynamic key, T defaultValue) {
    return _config[key] ?? defaultValue;
  }

  void setValue(dynamic key, dynamic value) {
    _config[key] = value;
    File(appConfigPath).writeAsStringSync(json.encode(_config));
  }

  Future removeValue(dynamic key) async {
    _config.remove(key);
    File(appConfigPath).writeAsStringSync(json.encode(_config));
  }

  Future initChromeDataPath() async {
    if (!Directory(chromeDataPath).existsSync()) {
      Directory(chromeDataPath).createSync(recursive: true);
    } else {
      await Directory(chromeDataPath).delete(recursive: true);
      Directory(chromeDataPath).createSync(recursive: true);
    }
  }
}
