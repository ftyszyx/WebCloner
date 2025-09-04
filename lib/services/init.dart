import 'package:get/get.dart';
import 'account_service.dart';
import 'task_service.dart';
import 'web_clone_service.dart';
import 'app_config_service.dart';
import 'logger.dart';
import 'resource_service.dart';

class ServiceManager {
  static Future<void> initWithProgress(void Function(double progress, String message) onProgress) async {
    onProgress(0.05, '初始化配置...');
    await Get.put(AppConfigService()).init();

    onProgress(0.15, '检测并下载浏览器...');
    await Get.put(ResourceService()).init();

    onProgress(0.45, '载入账号服务...');
    await Get.put(AccountService()).init();

    onProgress(0.65, '载入任务服务...');
    await Get.put(TaskService()).init();

    onProgress(0.80, '初始化日志...');
    await logger.initialize();

    onProgress(0.90, '启动后台任务...');
    await Get.put(WebCloneService()).init();
    WebCloneService.instance.startLoop();

    onProgress(1.0, '完成');
  }
}
