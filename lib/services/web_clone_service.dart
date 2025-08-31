import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/utils/logger.dart';

class WebCloneService {
  static const String _outputDir = 'cloned_sites';

  Future<void> init() async {
    // 创建输出目录
    final appDir = await getApplicationSupportDirectory();
    final outputPath = path.join(appDir.path, _outputDir);
    final outputDir = Directory(outputPath);
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }
  }

  Future<void> cloneWebsite(Task task) async {
    try {
      logger.info('Starting website clone for task: ${task.name}');
      
      // 创建任务特定的输出目录
      final outputPath = await _createTaskOutputDir(task);
      
      switch (task.type) {
        case TaskType.singlePage:
          await _cloneSinglePage(task, outputPath);
          break;
        case TaskType.multiPage:
          await _cloneMultiPage(task, outputPath);
          break;
        case TaskType.fullSite:
          await _cloneFullSite(task, outputPath);
          break;
      }
      
      logger.info('Website clone completed for task: ${task.name}');
    } catch (e) {
      logger.error('Error cloning website for task: ${task.name}', error: e);
      rethrow;
    }
  }

  Future<String> _createTaskOutputDir(Task task) async {
    final appDir = await getApplicationSupportDirectory();
    final taskDir = path.join(appDir.path, _outputDir, task.id);
    final dir = Directory(taskDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return taskDir;
  }

  Future<void> _cloneSinglePage(Task task, String outputPath) async {
    // 单页面克隆逻辑
    await _captureScreenshot(task.url, outputPath, 'page.png');
    await _saveHtml(task.url, outputPath, 'page.html');
    await _generateDirectory(outputPath, [task.url]);
  }

  Future<void> _cloneMultiPage(Task task, String outputPath) async {
    // 多页面克隆逻辑
    final urls = await _extractPageUrls(task.url);
    task = task.copyWith(totalPages: urls.length);
    
    for (int i = 0; i < urls.length; i++) {
      final url = urls[i];
      final fileName = 'page_${(i + 1).toString().padLeft(3, '0')}';
      
      await _captureScreenshot(url, outputPath, '$fileName.png');
      await _saveHtml(url, outputPath, '$fileName.html');
      
      // 更新任务进度
      task = task.copyWith(completedPages: i + 1);
    }
    
    await _generateDirectory(outputPath, urls);
  }

  Future<void> _cloneFullSite(Task task, String outputPath) async {
    // 全站克隆逻辑
    final urls = await _crawlSite(task.url);
    task = task.copyWith(totalPages: urls.length);
    
    for (int i = 0; i < urls.length; i++) {
      final url = urls[i];
      final fileName = 'page_${(i + 1).toString().padLeft(3, '0')}';
      
      await _captureScreenshot(url, outputPath, '$fileName.png');
      await _saveHtml(url, outputPath, '$fileName.html');
      
      // 更新任务进度
      task = task.copyWith(completedPages: i + 1);
    }
    
    await _generateDirectory(outputPath, urls);
  }

  Future<void> _captureScreenshot(String url, String outputPath, String fileName) async {
    // 这里应该实现实际的截图逻辑
    // 可以使用webview_flutter或其他截图库
    logger.info('Capturing screenshot for: $url');
    
    // 模拟截图过程
    await Future.delayed(const Duration(seconds: 1));
    
    // 创建占位图片文件
    final file = File(path.join(outputPath, fileName));
    await file.writeAsBytes(Uint8List(0));
  }

  Future<void> _saveHtml(String url, String outputPath, String fileName) async {
    // 保存HTML内容
    logger.info('Saving HTML for: $url');
    
    try {
      final response = await HttpClient().getUrl(Uri.parse(url));
      final httpResponse = await response.close();
      final html = await httpResponse.transform(utf8.decoder).join();
      
      final file = File(path.join(outputPath, fileName));
      await file.writeAsString(html);
    } catch (e) {
      logger.error('Error saving HTML for: $url', error: e);
    }
  }

  Future<List<String>> _extractPageUrls(String baseUrl) async {
    // 提取页面URL的逻辑
    // 这里应该实现实际的URL提取
    return [baseUrl];
  }

  Future<List<String>> _crawlSite(String baseUrl) async {
    // 爬取全站URL的逻辑
    // 这里应该实现实际的网站爬取
    return [baseUrl];
  }

  Future<void> _generateDirectory(String outputPath, List<String> urls) async {
    // 生成网页目录
    final directoryFile = File(path.join(outputPath, 'directory.txt'));
    final content = StringBuffer();
    content.writeln('Web Cloner Directory');
    content.writeln('Generated: ${DateTime.now()}');
    content.writeln('');
    content.writeln('Pages:');
    
    for (int i = 0; i < urls.length; i++) {
      content.writeln('${i + 1}. ${urls[i]}');
    }
    
    await directoryFile.writeAsString(content.toString());
  }
}
