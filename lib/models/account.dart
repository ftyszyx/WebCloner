import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  String platform;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? lastLoginAt;

  @HiveField(7)
  bool isActive;

  Account({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.platform,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
  });

  Account copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    String? platform,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'platform': platform,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      password: json['password'],
      platform: json['platform'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }
}
