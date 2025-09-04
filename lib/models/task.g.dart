// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 2;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      name: fields[1] as String,
      url: fields[10] as String,
      domainList: (fields[12] as List).cast<String>(),
      urlPatterns: (fields[11] as List?)?.cast<String>(),
      captureUrlPatterns: (fields[13] as List?)?.cast<String>(),
      ignoreUrlPatterns: (fields[14] as List?)?.cast<String>(),
      status: fields[20] as TaskStatus,
      createdAt: fields[30] as DateTime,
      startedAt: fields[31] as DateTime?,
      completedAt: fields[32] as DateTime?,
      totalPages: fields[40] as int,
      visitedNum: fields[44] as int?,
      outputPath: fields[50] as String?,
      errorMessage: fields[60] as String?,
      maxPages: fields[42] as int,
      captureNum: fields[43] as int?,
      accountId: fields[70] as String?,
      maxTaskNum: fields[80] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.url)
      ..writeByte(11)
      ..write(obj.urlPatterns)
      ..writeByte(12)
      ..write(obj.domainList)
      ..writeByte(13)
      ..write(obj.captureUrlPatterns)
      ..writeByte(14)
      ..write(obj.ignoreUrlPatterns)
      ..writeByte(20)
      ..write(obj.status)
      ..writeByte(30)
      ..write(obj.createdAt)
      ..writeByte(31)
      ..write(obj.startedAt)
      ..writeByte(32)
      ..write(obj.completedAt)
      ..writeByte(40)
      ..write(obj.totalPages)
      ..writeByte(42)
      ..write(obj.maxPages)
      ..writeByte(43)
      ..write(obj.captureNum)
      ..writeByte(44)
      ..write(obj.visitedNum)
      ..writeByte(50)
      ..write(obj.outputPath)
      ..writeByte(60)
      ..write(obj.errorMessage)
      ..writeByte(70)
      ..write(obj.accountId)
      ..writeByte(80)
      ..write(obj.maxTaskNum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
