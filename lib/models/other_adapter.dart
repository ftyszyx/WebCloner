import 'package:hive/hive.dart';
import 'package:web_cloner/models/task.dart';
import 'package:puppeteer/protocol/network.dart';
import 'dart:convert';

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 3;

  @override
  TaskStatus read(BinaryReader reader) {
    return TaskStatus.values[reader.read()];
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    writer.write(obj.index);
  }
}

class CookieAdapter extends TypeAdapter<Cookie> {
  @override
  final int typeId = 8; // ensure unique id across adapters

  @override
  Cookie read(BinaryReader reader) {
    final json = jsonDecode(reader.readString());
    return Cookie.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, Cookie obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
