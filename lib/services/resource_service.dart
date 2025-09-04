import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';
import 'app_config_service.dart';
import 'logger.dart';

class ResourceService extends GetxService {
  static ResourceService get instance => Get.find<ResourceService>();

  final String chromeZipUrl = 'https://bytefuse.oss-cn-guangzhou.aliyuncs.com/res/chrome-win140.0.7281.0.zip';

  final RxDouble progress = 0.0.obs;
  final RxString message = '准备下载...'.obs;

  Future init() async {
    await _ensureChrome();
  }

  Future _ensureChrome() async {
    final destDir = path.join(AppConfigService.instance.appDataPath, 'chrome-win');
    final chromeExe = path.join(destDir, 'chrome.exe');
    if (File(chromeExe).existsSync()) return;

    logger.info('开始下载 Chrome 资源...');
    message.value = '正在下载浏览器...';
    final tmpZip = path.join(AppConfigService.instance.appCachePath, 'chrome-win.zip');
    await _downloadFile(
      chromeZipUrl,
      tmpZip,
      onProgress: (received, total) {
        if (total <= 0) return;
        progress.value = received / total;
        message.value = '下载中 ${(progress.value * 100).toStringAsFixed(0)}%';
      },
    );
    logger.info('下载完成，开始解压...');
    message.value = '解压中...';
    await _unzip(tmpZip, AppConfigService.instance.appDataPath);
    File(tmpZip).deleteSync();

    await _normalizeChromeDir();
    logger.info('Chrome 资源准备完成: $destDir');
    progress.value = 1.0;
    message.value = '完成';
  }

  Future _downloadFile(String url, String savePath, {void Function(int received, int total)? onProgress}) async {
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
    extractArchiveToDisk(archive, outDir);
  }

  Future _normalizeChromeDir() async {
    final appData = AppConfigService.instance.appDataPath;
    final expectedDir = Directory(path.join(appData, 'chrome-win'));
    if (File(path.join(expectedDir.path, 'chrome.exe')).existsSync()) return;
    final candidates = Directory(appData)
        .listSync()
        .whereType<Directory>()
        .where((d) => File(path.join(d.path, 'chrome.exe')).existsSync())
        .toList();
    if (candidates.isEmpty) {
      throw Exception('解压后未找到 chrome.exe');
    }
    final src = candidates.first;
    if (expectedDir.existsSync()) {
      await expectedDir.delete(recursive: true);
    }
    await src.rename(expectedDir.path);
  }
}
