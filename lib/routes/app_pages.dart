import 'package:get/get.dart';
import 'package:web_cloner/modules/account/account_page.dart';
import 'package:web_cloner/modules/task/task_page.dart';
import 'package:web_cloner/modules/home/home_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: Routes.account,
      page: () => const AccountPage(),
    ),
    GetPage(
      name: Routes.task,
      page: () => const TaskPage(),
    ),
  ];
}
