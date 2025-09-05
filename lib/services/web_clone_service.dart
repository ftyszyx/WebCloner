import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:lpinyin/lpinyin.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/app_config_service.dart';
import 'package:web_cloner/services/logger.dart';
import 'package:web_cloner/services/brower_service.dart';
import 'package:web_cloner/services/account_service.dart';
import 'package:web_cloner/services/task_service.dart';
import 'package:puppeteer/puppeteer.dart' as puppeteer;
import 'package:puppeteer/protocol/network.dart' as puppeteer_network;

class WebInfo {
  String title;
  String url;
  String pngPath;
  bool visited;
  bool isCaptured;
  WebInfo({
    required this.title,
    required this.url,
    required this.pngPath,
    this.visited = false,
    this.isCaptured = false,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'pngPath': pngPath,
    'visited': visited,
    'isCaptured': isCaptured,
  };

  factory WebInfo.fromJson(Map<String, dynamic> json) => WebInfo(
    title: json['title'],
    url: json['url'],
    pngPath: json['pngPath'],
    visited: json['visited'] ?? false,
    isCaptured: json['isCaptured'] ?? false,
  );
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
    _CloneContext? ctx;
    try {
      ctx = await _prepareCloneContext(task);
      await _runMainLoop(ctx);
      logger.info("任务结束");
      task.status = TaskStatus.completed;
      TaskService.instance.completeTask(
        task.id,
        ctx.validWebsList.length,
        ctx.visitedPages,
        ctx.capturedPages,
        ctx.outputPath,
      );
    } catch (e, s) {
      logger.error('克隆网站失败: ${task.name}', error: e, stackTrace: s);
      TaskService.instance.failTask(task.id, e.toString());
    } finally {
      if (ctx != null && ctx.validWebsList.isNotEmpty) {
        logger.info("保存数据");
        ctx.validWebsList.sort((a, b) {
          final String pinyinA = PinyinHelper.getPinyinE(a.title);
          final String pinyinB = PinyinHelper.getPinyinE(b.title);
          return pinyinA.compareTo(pinyinB);
        });
        await _generateIndexHtml(ctx.validWebsList, task);
        await _saveTaskHistory(task, ctx.validWebsList);
      }
      await ctx?.session.close();
    }
  }

  Future<_CloneContext> _prepareCloneContext(Task task) async {
    TaskService.instance.updateTaskStatus(task.id, TaskStatus.running);
    logger.info('开始克隆网站: ${task.name} url: ${task.url}');
    final outputPath = await _createTaskOutputDir(task);
    final validWebsList = await _getTaskHistory(task);
    validWebsList.removeWhere((x) => _checkUrlIsValid(x.url, task) == false);
    final needVisitWebInfos = Queue<WebInfo>();
    final validWebDic = <String, WebInfo>{};
    int visitedPages = 0;
    int capturedPages = 0;
    for (var x in validWebsList) {
      validWebDic[x.url] = x;
      if (x.isCaptured) {
        capturedPages++;
      }
      if (x.visited && x.title.isNotEmpty) {
        visitedPages++;
      } else {
        needVisitWebInfos.add(x);
      }
    }
    List<puppeteer_network.Cookie> cookies = [];
    if (task.accountId != null && task.accountId!.isNotEmpty) {
      try {
        final account = await AccountService.instance.getAccountById(
          task.accountId!,
        );
        cookies = account?.cookies ?? [];
      } catch (e) {
        logger.error('读取账号Cookies失败: $e');
      }
    }
    final session = await BrowerService.instance.runBrowser(
      forceShowBrowser: true,
    );
    final ctx = _CloneContext(
      svc: this,
      task: task,
      outputPath: outputPath,
      validWebsList: validWebsList,
      needVisitWebInfos: needVisitWebInfos,
      validWebDic: validWebDic,
      visitedPages: visitedPages,
      capturedPages: capturedPages,
      cookies: cookies,
      session: session,
    );
    if (validWebsList.isEmpty) {
      ctx.addNewUrl(task.url);
    }
    return ctx;
  }

  Future<void> _runMainLoop(_CloneContext ctx) async {
    final Set<Future<void>> active = <Future<void>>{};
    bool hasCapacity() {
      if (ctx.task.maxPages <= 0) return true;
      return ctx.capturedPages < ctx.task.maxPages;
    }

    while ((ctx.needVisitWebInfos.isNotEmpty && hasCapacity()) ||
        active.isNotEmpty) {
      while (active.length < ctx.task.maxConcurrent &&
          ctx.needVisitWebInfos.isNotEmpty &&
          hasCapacity() &&
          ctx.task.status != TaskStatus.paused) {
        final f = _startOne(ctx);
        active.add(f);
        f.whenComplete(() {
          active.remove(f);
        });
      }
      if (ctx.task.status == TaskStatus.paused) {
        break;
      }
      if (ctx.task.maxPages > 0 && ctx.capturedPages >= ctx.task.maxPages) {
        logger.info('超过最大数量: ${ctx.task.maxPages}');
        break;
      }
      if (active.isEmpty) {
        break;
      }
      await Future.any(active);
    }
  }

  Future<void> _startOne(_CloneContext ctx) async {
    if (ctx.needVisitWebInfos.isEmpty) return;
    final info = ctx.needVisitWebInfos.removeFirst();
    info.visited = true;
    ctx.visitedPages++;
    final (isOk, errMesg) = await _scrawlSite(
      ctx.session,
      info,
      ctx.cookies,
      ctx.addNewUrl,
      ctx.task,
    );
    if (isOk) {
      info.isCaptured = true;
      ctx.capturedPages++;
    }
    TaskService.instance.updateTaskProgress(
      ctx.task.id,
      ctx.validWebsList.length,
      ctx.capturedPages,
      ctx.visitedPages,
    );
  }

  String _getTaskOutputDir(Task task) {
    return path.join(AppConfigService.instance.outputDir, task.id);
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

  Future<void> _addAllLinks(
    puppeteer.Page page,
    Function(String) onAddNewUrl,
  ) async {
    final links = await page.evaluate<List<dynamic>>(
      '() => Array.from(document.querySelectorAll("a[href]")).filter(a => ["http:", "https:"] .includes(a.protocol)).map(a => a.href)',
    );
    for (var link in links) {
      final url = Uri.parse(link).toString();
      onAddNewUrl(url);
    }
  }

  Future<void> _scrollToBottom(puppeteer.Page page) async {
    logger.info('滚动到页面底部');
    await page.evaluate('''
             async () => {
               const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
               const body = document.body;
               const html = document.documentElement;
               const height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
               for (let i = 0; i < height; i += 100) {
                 window.scrollTo(0, i);
                 await sleep(50);
               }
              await sleep(50);
             }
           ''');
  }

  Future<void> _waitPageAllImagesLoaded(puppeteer.Page page, String url) async {
    try {
      //wait page all images loaded
      logger.info('等待页面所有图片加载完成');
      await page.waitForFunction('''
   () => {
     const images = Array.from(document.querySelectorAll('img'));
     if (images.length === 0) return true;
     // Check if all images are settled (either loaded successfully or failed)
     return images.every(img => img.complete);
   }
 ''', timeout: const Duration(seconds: 30));
    } catch (e, s) {
      logger.error('等待页面所有图片加载完成失败: $url, ', error: e, stackTrace: s);
    }
  }

  //爬取网站
  Future<(bool, String)> _scrawlSite(
    BrowserSession session,
    WebInfo info,
    List<puppeteer_network.Cookie> cookies,
    Function(String) onAddNewUrl,
    Task task,
  ) async {
    logger.info('goto url: ${info.url}');
    final page = await session.waitForNotBusyPage(cookies: cookies);
    try {
      page.inUse = true;
      await page.goto(
        info.url,
        wait: puppeteer.Until.domContentLoaded,
        timeout: const Duration(minutes: 10),
      );
      await _scrollToBottom(page);
      //get title
      final title = await page.title ?? '';
      info.title = title;
      _addAllLinks(page, onAddNewUrl);
      try {
        while (true) {
          final clicked = await page.evaluate<bool>(
            r'''(() => {
            function isRealHref(el){if(!el||el.tagName!=='A')return false;const href=(el.getAttribute('href')||'').trim();if(!href)return false;try{const u=new URL(href,document.baseURI);return u.protocol==='http:'||u.protocol==='https:';}catch(e){return false;}}
            const NEXT_EXACT=/^(下一页|下一頁|下页|更多|Next|More|Older|next|more|older)$/i;
            const NEXT_PARTIAL=/(下一页|下一頁|下页|更多|Next|More|Older|next|more|older)/i;
            const links=Array.from(document.querySelectorAll('a,button'));
            //by rel
            const byRel=document.querySelector('a[rel=next]');
            if(byRel && !(byRel.tagName==='A' && isRealHref(byRel))){byRel.click();return true;}
            //by aria
            const byAria=links.find(el=>NEXT_PARTIAL.test((el.getAttribute('aria-label')||el.title||'')) && !(el.tagName==='A' && isRealHref(el)));
            if(byAria){byAria.click();return true;}
            //by text
            const byText=links.find(el=>NEXT_EXACT.test((el.textContent||'').trim()) && !(el.tagName==='A' && isRealHref(el)));
            if(byText){byText.click();return true;}
            //by css
            const cssCandidates=['.next','.pagination-next','.ant-pagination-next','.el-pagination__next','[data-next=true]'];
            for(const sel of cssCandidates){const el=document.querySelector(sel);
            if(el && !(el.tagName==='A' && isRealHref(el))){el.click();return true;}}return false;})()''',
          );
          if (clicked != true) break;
          await page.waitForNavigation(
            wait: puppeteer.Until.networkIdle,
            timeout: const Duration(seconds: 10),
          );
          await Future.delayed(const Duration(milliseconds: 1000));
          _addAllLinks(page, onAddNewUrl);
        }
      } catch (e, s) {
        logger.error('分页查找与点击失败: ${info.url}', error: e, stackTrace: s);
      }
      if (task.isUrlNeedCapture(info.url) && info.isCaptured == false) {
        await _scrollToBottom(page);
        await _waitPageAllImagesLoaded(page, info.url);
        try {
          logger.info('开始截图: ${info.url}');
          final bytes = await page.screenshot(fullPage: true);
          final file = File(info.pngPath);
          await file.writeAsBytes(bytes);
          return (true, "");
        } catch (e, s) {
          logger.error('截图失败: ${info.url}, ', error: e, stackTrace: s);
          return (false, "截图失败: ${info.url}, $e");
        }
      } else {
        return (false, "url is not need capture");
      }
    } finally {
      page.inUse = false;
    }
  }

  String _getTaskHistoryFileListPath(Task task) {
    return path.join(_getTaskOutputDir(task), 'history.json');
  }

  Future<void> _saveTaskHistory(Task task, List<WebInfo> items) async {
    final outputPath = _getTaskHistoryFileListPath(task);
    const encoder = JsonEncoder.withIndent('  ');
    final formattedJson = encoder.convert(items);
    await File(outputPath).writeAsString(formattedJson);
  }

  Future<List<WebInfo>> _getTaskHistory(Task task) async {
    final outputPath = _getTaskHistoryFileListPath(task);
    if (File(outputPath).existsSync()) {
      final content = await File(outputPath).readAsString();
      if (content.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((json) => WebInfo.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _generateIndexHtml(List<WebInfo> items, Task task) async {
    final outputPath = _getTaskOutputDir(task);
    final buf = StringBuffer();
    buf.writeln('<!DOCTYPE html>');
    buf.writeln(
      '<html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Web Cloner Index</title>',
    );
    buf.writeln(
      '<style>body{max-width:1100px;margin:0 auto;padding:24px;font-family:system-ui}h1{margin:0 0 16px}#searchbar{position:sticky;top:0;background:#fff;padding:12px 0;z-index:10}#search{width:100%;padding:12px 14px;border:1px solid #ddd;border-radius:8px;font-size:14px}#alpha-nav{display:flex;flex-wrap:wrap;gap:6px;margin:12px 0 16px}#alpha-nav a{display:inline-block;padding:6px 10px;border:1px solid #ddd;border-radius:6px;text-decoration:none;color:#333}#alpha-nav a:hover{background:#f5f5f5}.group{margin:18px 0 8px;border-bottom:1px solid #eee;padding-bottom:4px}.group-list{list-style:none;padding:0;display:grid;grid-template-columns:repeat(auto-fill,minmax(300px,1fr));gap:10px}.item{border:1px solid #ddd;border-radius:6px;padding:10px}.item a{text-decoration:none;color:#0a58ca;word-break:break-all}.item small{color:#666}</style>',
    );
    buf.writeln('</head><body>');
    buf.writeln('<h1>克隆页面索引</h1>');
    buf.writeln(
      '<div id="searchbar"><input id="search" type="text" placeholder="搜索标题或URL..." /></div>',
    );
    // 分组: 按标题拼音首字母 (A-Z), 其他归为 '#'
    final Map<String, List<WebInfo>> groups = <String, List<WebInfo>>{};
    for (final it in items) {
      if (it.isCaptured == false) continue;
      final String pinyin = PinyinHelper.getPinyinE(it.title);
      String letter = pinyin.isNotEmpty ? pinyin[0].toUpperCase() : '#';
      if (!RegExp(r'^[A-Z]$').hasMatch(letter)) {
        letter = '#';
      }
      groups.putIfAbsent(letter, () => <WebInfo>[]).add(it);
    }
    final List<String> order = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
      '#',
    ];
    final List<String> present = order
        .where((l) => groups.containsKey(l))
        .toList();

    // 字母索引导航
    buf.writeln('<div id="alpha-nav">');
    for (final l in present) {
      buf.writeln('<a href="#sec-$l">$l</a>');
    }
    buf.writeln('</div>');

    // 分组列表
    for (final l in present) {
      buf.writeln('<h2 class="group" id="sec-$l">$l</h2>');
      buf.writeln('<ul class="group-list">');
      final list = groups[l]!;
      for (int i = 0; i < list.length; i++) {
        final it = list[i];
        final pngName = path.basename(it.pngPath);
        final escTitle = _escapeHtml(it.title);
        final escUrl = _escapeHtml(it.url);
        final dataTitle = _escapeHtml(it.title.toLowerCase());
        final dataUrl = _escapeHtml(it.url.toLowerCase());
        buf.writeln(
          '<li class="item" data-title="$dataTitle" data-url="$dataUrl"><a href="resources/$pngName">$escTitle</a> — <small>$escUrl</small></li>',
        );
      }
      buf.writeln('</ul>');
    }

    // 简单前端搜索脚本
    buf.writeln('''
<script>
const q = document.getElementById("search");
function applyFilter() {
  const s = (q.value || "").trim().toLowerCase();
  const groups = Array.from(document.querySelectorAll("h2.group"));
  groups.forEach(g => {
    const ul = g.nextElementSibling;
    if (!ul) return;
    let visible = 0;
    ul.querySelectorAll("li.item").forEach(li => {
      const t = li.dataset.title || "";
      const u = li.dataset.url || "";
      const ok = s === "" || t.includes(s) || u.includes(s);
      li.style.display = ok ? "" : "none";
      if (ok) visible++;
    });
    g.style.display = visible > 0 ? "" : "none";
    ul.style.display = visible > 0 ? "" : "none";
  });
}
q.addEventListener("input", applyFilter);
</script>
''');
    buf.writeln('</body></html>');
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
      if (task.isUrlIgnore(url)) {
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

class _CloneContext {
  final WebCloneService svc;
  final Task task;
  final String outputPath;
  final List<WebInfo> validWebsList;
  final Queue<WebInfo> needVisitWebInfos;
  final Map<String, WebInfo> validWebDic;
  int visitedPages;
  int capturedPages;
  final List<puppeteer_network.Cookie> cookies;
  final BrowserSession session;

  _CloneContext({
    required this.svc,
    required this.task,
    required this.outputPath,
    required this.validWebsList,
    required this.needVisitWebInfos,
    required this.validWebDic,
    required this.visitedPages,
    required this.capturedPages,
    required this.cookies,
    required this.session,
  });

  void addNewUrl(String url) {
    //url 去掉#后面的字符
    url = url.split('#')[0];
    url = url.replaceAll('#', '');
    if (validWebDic.containsKey(url)) return;
    if (svc._checkUrlIsValid(url, task) == false) return;
    final info = WebInfo(
      url: url,
      pngPath: svc._getPngPath(task, url),
      title: '',
    );
    if (File(info.pngPath).existsSync()) {
      info.isCaptured = true;
      if (info.title.isNotEmpty) {
        info.visited = true;
        visitedPages++;
      }
      capturedPages++;
    } else {
      needVisitWebInfos.add(info);
    }
    validWebsList.add(info);
    validWebDic[url] = info;
  }
}
