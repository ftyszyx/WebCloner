import 'package:get/get.dart';
import 'package:web_cloner/modules/account/account_controller.dart';
import 'package:web_cloner/modules/account/account_page.dart';
import 'package:web_cloner/modules/splash/splash_page.dart';
import 'package:web_cloner/modules/task/task_controller.dart';
import 'package:web_cloner/modules/task/task_page.dart';
import 'package:web_cloner/modules/home/home_page.dart';
import 'package:web_cloner/modules/settings/settings_page.dart';
import 'package:web_cloner/modules/settings/settings_controller.dart';
import 'package:web_cloner/modules/logs/logs_page.dart';
import 'package:web_cloner/modules/splash/splash_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SplashController());
      }),
    ),
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(
      name: Routes.account,
      page: () => const AccountPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AccountController());
      }),
    ),
    GetPage(
      name: Routes.task,
      page: () => const TaskPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TaskController());
      }),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SettingsController());
      }),
    ),
    GetPage(name: Routes.logs, page: () => const LogsPage()),
  ];
}
