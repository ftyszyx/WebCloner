import 'dart:ui';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_cloner/services/app_config_service.dart';

class SettingsController extends GetxController {
  final _cfg = AppConfigService.instance;
  final locale = ''.obs;
  final outputDir = ''.obs;

  @override
  void onInit() {
    super.onInit();
    locale.value = _cfg.getLocaleStr();
    outputDir.value = _cfg.outputDir;
  }

  void setLocale(String value) {
    locale.value = value;
    _cfg.setLocale(value);
    Get.updateLocale(Locale(value));
  }

  Future<void> chooseOutputDir(String? initialDirectory) async {
    final String? selected = await FilePicker.platform.getDirectoryPath(
      initialDirectory: initialDirectory,
    );
    if (selected != null && selected.isNotEmpty) {
      _cfg.setOutputDir(selected);
      outputDir.value = selected;
      Get.snackbar('Saved', 'Output directory updated');
    }
  }
}
