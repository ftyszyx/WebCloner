import 'package:hive/hive.dart';

part 'task.g.dart';

enum TaskStatus {
  init('Init'),
  pending('Pending'),
  running('Running'),
  completed('Completed'),
  failed('Failed'),
  paused('Paused');

  final String title;
  const TaskStatus(this.title);
}

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  //main url
  @HiveField(10)
  String url;

  //可以用正则表达式过滤url（支持多个规则）
  @HiveField(11)
  List<String>? urlPatterns;

  //允许的域名列表
  @HiveField(12)
  List<String> domainList;

  @HiveField(13)
  List<String>? captureUrlPatterns;

  @HiveField(14)
  List<String>? ignoreUrlPatterns;

  @HiveField(20)
  TaskStatus status;

  @HiveField(30)
  DateTime createdAt;

  @HiveField(31)
  DateTime? startedAt;

  @HiveField(32)
  DateTime? completedAt;

  @HiveField(40)
  int totalPages;

  @HiveField(42)
  int maxPages;

  @HiveField(43)
  int? captureNum;

  @HiveField(44)
  int? visitedNum;

  @HiveField(50)
  String? outputPath;

  @HiveField(60)
  String? errorMessage;

  @HiveField(70)
  String? accountId;

  @HiveField(80)
  int? maxTaskNum;

  Task({
    required this.id,
    required this.name,
    required this.url,
    required this.domainList,
    this.urlPatterns,
    this.captureUrlPatterns,
    this.ignoreUrlPatterns,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.totalPages = 0,
    this.visitedNum = 0,
    this.outputPath,
    this.errorMessage,
    this.maxPages = 0,
    this.captureNum,
    this.accountId,
    this.maxTaskNum = 1,
  });

  double get progress {
    if (totalPages == 0) return 0.0;
    if (visitedNum == null) return 0.0;
    return visitedNum! / totalPages;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'urlPattern': urlPatterns,
      'domainList': domainList,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalPages': totalPages,
      'visitedNum': visitedNum,
      'outputPath': outputPath,
      'errorMessage': errorMessage,
      'maxPages': maxPages,
      'accountId': accountId,
      'captureNum': captureNum,
      'captureUrlPattern': captureUrlPatterns,
      'ignoreUrlPattern': ignoreUrlPatterns?.join(','),
    };
  }

  Set<String>? _allowedDomains;
  Set<String> get allowedDomains {
    if (_allowedDomains == null) {
      _allowedDomains = <String>{};
      final baseHost = Uri.parse(url).host;
      _allowedDomains!.add(baseHost);
      if (domainList.isNotEmpty) {
        _allowedDomains!.addAll(domainList);
      }
    }
    return _allowedDomains!;
  }

  List<String>? _urlPatternRegex;
  List<String>? _captureUrlPatternRegex;

  //将通配符转换为正则表达式
  String _wildcardToRegex(String pattern) {
    pattern = pattern.replaceAll('*', '[^/]*');
    pattern = pattern.replaceAll('?', '[^/]+');
    return pattern;
  }

  bool isUrlValid(String url) {
    if (url == this.url) return true;
    if (urlPatterns == null || urlPatterns!.isEmpty) return true;
    _urlPatternRegex ??= urlPatterns!.map((e) => _wildcardToRegex(e)).toList();
    for (final regexStr in _urlPatternRegex!) {
      final regex = RegExp(regexStr);
      if (regex.hasMatch(url)) return true;
    }
    return false;
  }

  bool isUrlNeedCapture(String url) {
    if (captureUrlPatterns == null || captureUrlPatterns!.isEmpty) return true;
    _captureUrlPatternRegex ??= captureUrlPatterns!
        .map((e) => _wildcardToRegex(e))
        .toList();
    for (final regexStr in _captureUrlPatternRegex!) {
      final regex = RegExp(regexStr);
      if (regex.hasMatch(url)) return true;
    }
    return false;
  }

  List<String>? _ignoreUrlPatternRegexs;
  bool isUrlIgnore(String url) {
    if (ignoreUrlPatterns == null) return false;
    _ignoreUrlPatternRegexs ??= ignoreUrlPatterns!
        .map((e) => _wildcardToRegex(e))
        .toList();
    for (final regex in _ignoreUrlPatternRegexs!) {
      final reg = RegExp(regex);
      if (reg.hasMatch(url)) {
        return true;
      }
    }
    return false;
  }

  int get maxConcurrent {
    if (maxTaskNum != null && maxTaskNum! > 0) {
      return maxTaskNum!;
    }
    return 1;
  }
}
