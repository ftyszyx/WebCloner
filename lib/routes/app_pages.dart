import 'package:get/get.dart';
import 'package:web_cloner/modules/account/account_controller.dart';
import 'package:web_cloner/modules/account/account_page.dart';
import 'package:web_cloner/modules/task/task_controller.dart';
import 'package:web_cloner/modules/task/task_page.dart';
import 'package:web_cloner/modules/home/home_page.dart';
import 'package:web_cloner/modules/settings/settings_page.dart';
import 'package:web_cloner/modules/settings/settings_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
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
  ];
}
