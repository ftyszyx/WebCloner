import 'package:hive/hive.dart';

part 'task.g.dart';

enum TaskStatus {
  pending,
  running,
  completed,
  failed,
  paused
}

enum TaskType {
  singlePage,
  multiPage,
  fullSite
}

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String url;

  @HiveField(3)
  TaskType type;

  @HiveField(4)
  TaskStatus status;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? startedAt;

  @HiveField(7)
  DateTime? completedAt;

  @HiveField(8)
  int totalPages;

  @HiveField(9)
  int completedPages;

  @HiveField(10)
  String? outputPath;

  @HiveField(11)
  String? errorMessage;

  @HiveField(12)
  Map<String, dynamic>? settings;

  Task({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.totalPages = 0,
    this.completedPages = 0,
    this.outputPath,
    this.errorMessage,
    this.settings,
  });

  Task copyWith({
    String? id,
    String? name,
    String? url,
    TaskType? type,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? totalPages,
    int? completedPages,
    String? outputPath,
    String? errorMessage,
    Map<String, dynamic>? settings,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalPages: totalPages ?? this.totalPages,
      completedPages: completedPages ?? this.completedPages,
      outputPath: outputPath ?? this.outputPath,
      errorMessage: errorMessage ?? this.errorMessage,
      settings: settings ?? this.settings,
    );
  }

  double get progress {
    if (totalPages == 0) return 0.0;
    return completedPages / totalPages;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type.toString(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalPages': totalPages,
      'completedPages': completedPages,
      'outputPath': outputPath,
      'errorMessage': errorMessage,
      'settings': settings,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: TaskType.values.firstWhere((e) => e.toString() == json['type']),
      status: TaskStatus.values.firstWhere((e) => e.toString() == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      totalPages: json['totalPages'] ?? 0,
      completedPages: json['completedPages'] ?? 0,
      outputPath: json['outputPath'],
      errorMessage: json['errorMessage'],
      settings: json['settings'],
    );
  }
}
