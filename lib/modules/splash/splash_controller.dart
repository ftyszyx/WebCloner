import 'package:get/get.dart';
import 'package:web_cloner/modules/core/event.dart';
import 'package:web_cloner/routes/app_pages.dart';
import 'package:web_cloner/services/init.dart';
import 'package:web_cloner/services/resource_service.dart';
import 'package:web_cloner/utils/event_bus.dart';

class SplashController extends GetxController {
  final RxDouble progress = 0.0.obs;
  final RxString message = 'Initializing...'.obs;

  @override
  void onInit() {
    super.onInit();
    EventBus.instance.listen(Event.loadingProgress, onLoadingProgress);
    _start();
  }

  void onLoadingProgress(double progress, String message) {
    this.progress.value = progress.clamp(0, 1);
    this.message.value = message;
  }

  Future<void> _start() async {
    try {
      final rs = Get.put(ResourceService());
      ever<double>(rs.progress, (p) => progress.value = p);
      ever<String>(rs.message, (m) => message.value = m);
      await ServiceManager.initWithProgress((p, msg) {
        progress.value = p.clamp(0, 1);
        message.value = msg;
      });
      Get.offAllNamed(Routes.home);
    } catch (e) {
      message.value = '初始化失败：$e';
    }
  }
}


