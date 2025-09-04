import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:web_cloner/l10n/app_localizations.dart';
import 'package:web_cloner/models/init.dart';
import 'package:web_cloner/routes/app_pages.dart';
import 'package:web_cloner/services/app_config_service.dart';
import 'package:web_cloner/services/init.dart';
import 'package:web_cloner/utils/common.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initWindow();
  final appDocsDir = await getApplicationSupportDirectory();
  await Hive.initFlutter(
    (!Platform.isAndroid && !Platform.isIOS) ? appDocsDir.path : null,
  );
  await initServices();
  runApp(const MyApp());
}

Future initWindow() async {
  if (!(Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    return;
  }
  await windowManager.ensureInitialized();
  const WindowOptions windowOptions = WindowOptions(
    minimumSize: Size(1200, 800),
    center: true,
    title: "Web Cloner",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

Future initServices() async {
  await ModelManager.init();
  CommonUtils.packageInfo = await PackageInfo.fromPlatform();
  await ServiceManager.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Web Cloner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Internationalization settings
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: AppConfigService.instance.getLocale(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      builder: FlutterSmartDialog.init(),
    );
  }
}
