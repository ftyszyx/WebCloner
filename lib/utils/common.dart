import 'package:package_info_plus/package_info_plus.dart';

class CommonUtils {
  static PackageInfo? packageInfo;

  static String getAppVersion() {
    return packageInfo?.version ?? 'Unknown';
  }

  static String getAppName() {
    return packageInfo?.appName ?? 'Web Cloner';
  }

  static String getBuildNumber() {
    return packageInfo?.buildNumber ?? 'Unknown';
  }

  static String getPackageName() {
    return packageInfo?.packageName ?? 'Unknown';
  }
}
