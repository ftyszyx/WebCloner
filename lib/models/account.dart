import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:puppeteer/protocol/network.dart';
part 'account.g.dart';

@HiveType(typeId: 1)
class Account extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String url;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(8)
  List<Cookie>? cookies;

  Account({
    required this.id,
    required this.name,
    required this.url,
    this.cookies,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'cookies': jsonEncode(cookies),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
