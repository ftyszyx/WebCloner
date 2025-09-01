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

  //base url
  @HiveField(10)
  String url;

  //可以用正则表达式过滤url
  @HiveField(11)
  String? urlPattern;

  //允许的域名列表
  @HiveField(12)
  List<String> domainList;

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

  @HiveField(41)
  int completedPages;

  @HiveField(42)
  int maxPages;

  @HiveField(50)
  String? outputPath;

  @HiveField(60)
  String? errorMessage;

  @HiveField(70)
  String? accountId;

  Task({
    required this.id,
    required this.name,
    required this.url,
    required this.domainList,
    this.urlPattern,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.totalPages = 0,
    this.completedPages = 0,
    this.outputPath,
    this.errorMessage,
    this.maxPages = 0,
    this.accountId,
  });

  double get progress {
    if (totalPages == 0) return 0.0;
    return completedPages / totalPages;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'urlPattern': urlPattern,
      'domainList': domainList,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalPages': totalPages,
      'completedPages': completedPages,
      'outputPath': outputPath,
      'errorMessage': errorMessage,
      'maxPages': maxPages,
      'accountId': accountId,
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

  String? _urlPatternRegex;
  String? get urlPatternRegex {
    if (urlPattern == null) return null;
    if (_urlPatternRegex != null) return _urlPatternRegex;
    _urlPatternRegex = _wildcardToRegex(urlPattern!);
    return _urlPatternRegex;
  }

  //将通配符转换为正则表达式
  String _wildcardToRegex(String pattern) {
    pattern = pattern.replaceAllMapped(RegExp(r'[.+?^${}()|[\]\\]'), (match) {
      return '\\${match[0]}';
    });
    return pattern.replaceAll('*', '.*');
  }
}
