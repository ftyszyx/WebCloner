import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';
import 'app_config_service.dart';
import 'logger.dart';
import 'package:web_cloner/utils/event_bus.dart';
import 'package:web_cloner/modules/core/event.dart';

class ResourceService extends GetxService {
  static ResourceService get instance => Get.find<ResourceService>();

  Future init() async {}

  Future checkResource() async {
    final destDir = AppConfigService.instance.chromeDir;
    if (await _checkChromeDir()) {
      logger.info('Chrome 资源已存在: ${AppConfigService.instance.chromeDir}');
      return;
    }
    if (Directory(destDir).existsSync()) {
      logger.info('删除 Chrome 资源: $destDir');
      await Directory(destDir).delete(recursive: true);
    }
    EventBus.instance.emit(Event.loadingProgress, (0.15, '正在下载浏览器...'));
    final tmpZip = path.join(
      AppConfigService.instance.appCachePath,
      'chrome-win.zip',
    );
    logger.info('开始下载 Chrome 资源...to:$tmpZip');
    await _downloadFile(
      AppConfigService.instance.chromeAssetUrl,
      tmpZip,
      onProgress: (received, total) {
        if (total <= 0) return;
        EventBus.instance.emit(Event.loadingProgress, (
          received / total,
          '下载中 ${(received / total * 100).toStringAsFixed(0)}%',
        ));
      },
    );
    logger.info('下载完成，开始解压...');
    EventBus.instance.emit(Event.loadingProgress, (0.25, '解压中...'));
    await _unzip(tmpZip, AppConfigService.instance.chromeDir);
    File(tmpZip).deleteSync();
    if (!await _checkChromeDir()) {
      throw Exception('Chrome 资源解压失败');
    }
    logger.info('Chrome 资源准备完成: ${AppConfigService.instance.chromeDir}');
    EventBus.instance.emit(Event.loadingProgress, (0.35, '完成'));
  }

  Future _downloadFile(
    String url,
    String savePath, {
    void Function(int received, int total)? onProgress,
  }) async {
    final dio = Dio();
    await dio.download(
      url,
      savePath,
      options: Options(responseType: ResponseType.bytes),
      onReceiveProgress: onProgress,
    );
  }

  Future _unzip(String zipPath, String outDir) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    await extractArchiveToDisk(archive, outDir);
  }

  Future<bool> _checkChromeDir() async {
    final chromeDir = path.join(
      AppConfigService.instance.chromeDir,
      'chrome.exe',
    );
    if (File(chromeDir).existsSync()) return true;
    logger.info('Chrome 资源解压失败: $chromeDir');
    return false;
  }
}
