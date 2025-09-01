import 'package:get/get.dart';
import 'account_service.dart';
import 'task_service.dart';
import 'web_clone_service.dart';
import 'app_config_service.dart';
import 'logger.dart';

class ServiceManager {
  static Future<void> init() async {
    await Get.put(AppConfigService()).init();
    await Get.put(AccountService()).init();
    await Get.put(TaskService()).init();
    await Get.put(WebCloneService()).init();
    await logger.initialize();
    WebCloneService.instance.startLoop();
  }
}
