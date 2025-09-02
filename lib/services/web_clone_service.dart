import 'dart:collection';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/app_config_service.dart';
import 'package:web_cloner/services/logger.dart';
import 'package:web_cloner/services/brower_service.dart';
import 'package:web_cloner/services/account_service.dart';
import 'package:web_cloner/services/task_service.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:puppeteer/protocol/network.dart' as puppeteer_network;

class WebInfo {
  String title;
  String url;
  String pngPath;
  WebInfo({required this.title, required this.url, required this.pngPath});
}

class WebCloneService {
  static WebCloneService get instance => Get.find<WebCloneService>();

  List<Task> tasks = [];
  Future<void> init() async {}

  Future<void> startLoop() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      for (var task in tasks) {
        if (task.status == TaskStatus.pending) {
          await cloneWebsite(task);
        }
      }
    }
  }

  Future<void> addTask(Task task) async {
    task.status = TaskStatus.pending;
    tasks.add(task);
  }

  Future<void> cloneWebsite(Task task) async {
    BrowserSession? session;
    final List<WebInfo> okWebInfos = [];
    int totalPages = 0;
    try {
      TaskService.instance.updateTaskStatus(task.id, TaskStatus.running);
      logger.info(
        'Starting website clone for task: ${task.name} url: ${task.url}  urlPattern: ${task.urlPattern} ',
      );
      // 创建任务特定的输出目录
      final outputPath = await _createTaskOutputDir(task);
      _getOkForUrls(task, okWebInfos);
      final Set<String> okUrls = okWebInfos.map((e) => e.url).toSet();
      final Set<String> visitedUrls = <String>{};
      final Set<String> needVisitUrlSet = <String>{};
      final Queue<String> needVisitUrls = Queue();
      totalPages = visitedUrls.length;
      List<puppeteer_network.Cookie> cookies = [];
      if (task.accountId != null && task.accountId!.isNotEmpty) {
        try {
          final account = await AccountService.instance.getAccountById(
            task.accountId!,
          );
          cookies = account?.cookies ?? [];
          // logger.info('读取账号Cookies成功: ${jsonEncode(cookies)}');
        } catch (e) {
          logger.error('读取账号Cookies失败: $e');
        }
      }
      session = await BrowerService.instance.runBrowser(forceShowBrowser: true);
      needVisitUrls.add(task.url);
      needVisitUrlSet.add(task.url);
      while (needVisitUrls.isNotEmpty) {
        final url = needVisitUrls.removeFirst();
        final webInfo = WebInfo(
          url: url,
          pngPath: _getPngPath(task, url),
          title: '',
        );
        visitedUrls.add(url);
        final (isOk, errMesg) = await _scrawlSite(
          session,
          webInfo,
          okUrls,
          cookies,
          (url) {
            if (visitedUrls.contains(url)) {
              return;
            }
            if (_checkUrlIsValid(url, task) == false) {
              // logger.info('url is not valid: $url');
              return;
            }
            if (needVisitUrlSet.contains(url)) {
              return;
            }
            needVisitUrlSet.add(url);
            needVisitUrls.add(url);
            // logger.info('add url: $url');
            totalPages++;
          },
          task,
        );
        if (isOk) {
          okWebInfos.add(webInfo);
          if (task.maxPages > 0 && okWebInfos.length >= task.maxPages) {
            logger.info('超过最大数量: ${task.maxPages}');
            break;
          }
        }
        if (task.status == TaskStatus.paused) {
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
      logger.info("任务结束");
      if (okWebInfos.isNotEmpty) {
        await _generateIndexHtml(okWebInfos, task);
        await _saveOkForUrls(okWebInfos, task);
      }
      task.status = TaskStatus.completed;
      TaskService.instance.completeTask(
        task.id,
        totalPages,
        visitedUrls.length,
        okWebInfos.length,
        outputPath,
      );
    } catch (e, s) {
      logger.error(
        'Error cloning website for task: ${task.name}',
        error: e,
        stackTrace: s,
      );
      TaskService.instance.failTask(task.id, e.toString());
    } finally {
      await session?.close();
    }
  }

  String _getTaskOutputDir(Task task) {
    return path.join(AppConfigService.instance.outputDir, task.id);
  }

  String _getTaskOkFileListPath(Task task) {
    return path.join(_getTaskOutputDir(task), 'ok.txt');
  }


  String _getPngPath(Task task, String url) {
    return path.join(
      _getTaskOutputDir(task),
      "resources",
      '${url.hashCode}.png',
    );
  }

  Future<String> _createTaskOutputDir(Task task) async {
    final taskDir = _getTaskOutputDir(task);
    final dir = Directory(taskDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final resourcesDir = Directory(path.join(taskDir, "resources"));
    if (!resourcesDir.existsSync()) {
      resourcesDir.createSync(recursive: true);
    }
    return taskDir;
  }

  //爬取网站
  Future<(bool, String)> _scrawlSite(
    BrowserSession session,
    WebInfo info,
    Set<String> okUrls,
    List<puppeteer_network.Cookie> cookies,
    Function(String) onAddNewUrl,
    Task task,
  ) async {
    logger.info('goto url: ${info.url}');
    final page = await session.waitForNotBusyPage(cookies: cookies);
    try {
      page.isBusy = true;
      await page.goto(
        url: info.url,
        wait: Until.domContentLoaded,
        timeout: const Duration(minutes: 10),
      );
      //get title
      final title = await page.page.title ?? '';
      info.title = title;
      // logger.info('获取title: ${info.title}');
      //get all links from html
      final links = await page.page.evaluate<List<dynamic>>(
        '() => Array.from(document.querySelectorAll("a[href]")).filter(a => ["http:", "https:"] .includes(a.protocol)).map(a => a.href)',
      );
      for (var link in links) {
        final url = Uri.parse(link).toString();
        onAddNewUrl(url);
      }
      if (task.isUrlNeedCapture(info.url) &&
          okUrls.contains(info.url) == false) {
        try {
          //wait page all images loaded
          logger.info('等待页面所有图片加载完成');
          await page.page.waitForFunction('''
  () => {
    const images = document.querySelectorAll('img');
    if (images.length === 0) return true;
    
    return Array.from(images).every(img => {
      return img.complete && img.naturalHeight > 0;
    });
  }
''', timeout: const Duration(seconds: 60));
          logger.info('开始截图: ${info.url}');
          final bytes = await page.page.screenshot(fullPage: true);
          final file = File(info.pngPath);
          await file.writeAsBytes(bytes);
        } catch (e, s) {
          logger.error('截图失败: $info.url, ', error: e, stackTrace: s);
          return (false, "截图失败: $info.url, $e");
        }
        return (true, "");
      } else {
        return (false, "url is not need capture");
      }
    } finally {
      page.isBusy = false;
    }
  }

  Future<void> _saveOkForUrls(List<WebInfo> items, Task task) async {
    final outputPath = _getTaskOkFileListPath(task);
    await File(outputPath).writeAsString(
      items
          .map((e) => '${Uri.encodeFull(e.url)}|${e.pngPath}|${e.title}')
          .join('\n'),
    );
  }

  Future<void> _generateIndexHtml(List<WebInfo> items, Task task) async {
    final outputPath = _getTaskOutputDir(task);
    final buf = StringBuffer();
    buf.writeln('<!DOCTYPE html>');
    buf.writeln(
      '<html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Web Cloner Index</title>',
    );
    buf.writeln(
      '<style>body{max-width:1000px;margin:0 auto;padding:24px;font-family:system-ui}ul{list-style:none;padding:0;display:grid;gap:10px}li{border:1px solid #ddd;border-radius:6px;padding:10px}</style>',
    );
    buf.writeln('</head><body><h1>克隆页面索引</h1><ul>');
    for (int i = 0; i < items.length; i++) {
      final it = items[i];
      final pngName = path.basename(it.pngPath);
      buf.writeln(
        '<li>${i + 1}. <a href="resources/$pngName">${_escapeHtml(it.title)}</a> — <small>${_escapeHtml(it.url)}</small></li>',
      );
    }
    buf.writeln('</ul></body></html>');
    final file = File(path.join(outputPath, 'index.html'));
    await file.writeAsString(buf.toString());
  }

  String _escapeHtml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  void _getOkForUrls(Task task, List<WebInfo> okList) async {
    final savePath = _getTaskOkFileListPath(task);
    if (File(savePath).existsSync()) {
      //read file from json
      final linearr = File(savePath).readAsLinesSync();
      for (var line in linearr) {
        final itemarr = line.split('|');
        okList.add(
          WebInfo(url: itemarr[0], pngPath: itemarr[1], title: itemarr[2]),
        );
      }
    }
  }

  //  检查url是否有效
  bool _checkUrlIsValid(String url, Task task) {
    try {
      if (url.startsWith("http") == false && url.startsWith("https") == false) {
        return false;
      }
      final Uri uri = Uri.parse(url);
      if (!task.allowedDomains.contains(uri.host)) {
        return false;
      }
      if (!task.isUrlValid(url)) {
        return false;
      }
      return true;
    } catch (e, s) {
      logger.error(
        'Error checking URL is valid: $url',
        error: e,
        stackTrace: s,
      );
      return false;
    }
  }
}
