import 'dart:io';
import 'package:puppeteer/puppeteer.dart';
import 'package:web_cloner/services/app_config_service.dart';
import 'package:web_cloner/services/logger.dart';
import 'package:path/path.dart' as path;
import 'package:puppeteer/protocol/network.dart' as puppeteer_network;

class BrowserSession {
  final Browser? browser;
  final Page? page;
  final String? userDataDir;
  bool isClosed = false;
  BrowserSession({
    this.browser,
    this.page,
    this.userDataDir,
    this.isClosed = false,
  });

  Future<void> close() async {
    isClosed = true;
    await browser?.close();
    if (userDataDir != null) {
      await Directory(userDataDir!).delete(recursive: true);
    }
  }
}

class BrowerService {
  static BrowerService? _browerService;
  static BrowerService get instance {
    _browerService ??= BrowerService();
    return _browerService!;
  }

  List<BrowserSession> sessions = [];

  Future<void> init() async {
    sessions = [];
  }

  Future<void> close() async {
    for (var session in sessions) {
      if (session.isClosed) continue;
      await session.close();
    }
    sessions = [];
  }

  //https://peter.sh/experiments/chromium-command-line-switches/#net-log
  Future<BrowserSession> runBrowser({
    required String url,
    List<puppeteer_network.Cookie>? cookies,
    bool forceShowBrowser = false,
    Function(Request)? onRequest,
    Function(Response)? onResponse,
  }) async {
    try {
      final String exeDir = path.dirname(Platform.resolvedExecutable);
      final String chromiumPath = path.join(
        exeDir,
        'data',
        'flutter_assets',
        'assets',
        'chrome-win',
        'chrome.exe',
      );
      if (!await File(chromiumPath).exists()) {
        throw Exception('打包的 chrome.exe 未找到，路径: $chromiumPath');
      }
      final args = ['--disable-dev-shm-usage'];
      args.add('--no-sandbox');
      args.add('--disable-setuid-sandbox');
      args.add('--remote-debugging-port=0');
      if (AppConfigService.instance.isdebug) {
        args.add('--auto-open-devtools-for-tabs');
        args.add('--net-log');
        args.add('--unsafely-disable-devtools-self-xss-warnings'); // pasting
      }
      final showBrowser = AppConfigService.instance.isdebug || forceShowBrowser;
      if (!showBrowser) {
        args.add('--headless=new'); // 新 headless，Windows 更稳定
      }
      final userDataDir = path.join(
        AppConfigService.instance.chromeDataPath,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
      final browser = await puppeteer.launch(
        executablePath: chromiumPath,
        headless: !showBrowser,
        ignoreHttpsErrors: true,
        args: args,
        userDataDir: userDataDir,
      );
      final page = await browser.newPage();
      // page.onConsole.listen((event) {
      //   logger.d('browser_log: ${event.text}');
      // });
      page.onRequest.listen((request) {
        if (onRequest != null) {
          onRequest(request);
        }
      });
      page.onResponse.listen((response) {
        if (onResponse != null) {
          onResponse(response);
        }
      });
      await page.setUserAgent(AppConfigService.instance.userAgent);
      // await page.setUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1');
      if (cookies != null) {
        await page.setCookies(
          cookies
              .map(
                (e) =>
                    CookieParam(name: e.name, value: e.value, domain: e.domain),
              )
              .toList(),
        );
      }
      logger.info('浏览器正在导航到: $url chrome path: $chromiumPath ');
      await page.goto(
        url,
        wait: Until.domContentLoaded,
        timeout: const Duration(seconds: 0),
      );
      //set cookies
      logger.info('浏览器导航完成');
      final browserSession = BrowserSession(
        browser: browser,
        page: page,
        userDataDir: userDataDir,
      );
      sessions.add(browserSession);
      return browserSession;
    } catch (e, s) {
      logger.error('启动浏览器失败', error: e, stackTrace: s);
      throw Exception('启动浏览器失败 ');
    }
  }
}
