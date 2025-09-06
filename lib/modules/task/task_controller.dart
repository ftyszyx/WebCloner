import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/task_service.dart';
import 'package:web_cloner/services/web_clone_service.dart';
import 'package:web_cloner/widgets/task_form_dialog.dart';
import 'package:web_cloner/l10n/app_localizations.dart';

class TaskController extends GetxController {
  final _taskService = TaskService.instance;
  final _webCloneService = WebCloneService.instance;

  List<Task> get tasks => _taskService.tasks;

  void showAddTaskDialog() async {
    final result = await Get.dialog<Task>(const TaskFormDialog());
    if (result != null) {
      await _taskService.addTask(result);
    }
  }

  void showEditTaskDialog(Task task) async {
    final result = await Get.dialog<Task>(TaskFormDialog(task: task));
    if (result != null) {
      await _taskService.updateTask(result);
    }
  }

  void startTask(Task task) async {
    await _webCloneService.addTask(task);
  }

  void restartTask(Task task) async {
    task.totalPages = 0;
    task.visitedNum = 0;
    task.captureNum = 0;
    task.errorMessage = null;
    task.startedAt = null;
    task.completedAt = null;
    task.status = TaskStatus.paused;
    await _webCloneService.refreshTask(task);
    _taskService.updateTask(task);
  }

  Future<void> pauseTask(Task task) async {
    await _taskService.pauseTask(task.id);
  }

  Future<void> deleteTask(Task task) async {
    final l10n = AppLocalizations.of(Get.context!)!;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text(l10n.areYouSureYouWantToDelete(task.name)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _taskService.deleteTask(task.id);
      // loadTasks();
    }
  }

  void openTaskDirectory(Task task) {
    if (task.outputPath == null || task.outputPath!.isEmpty) {
      Get.snackbar('Error', 'Output path is not available for this task.');
      return;
    }
    try {
      if (Platform.isWindows) {
        Process.run('explorer', [task.outputPath!]);
      } else if (Platform.isMacOS) {
        Process.run('open', [task.outputPath!]);
      } else if (Platform.isLinux) {
        Process.run('xdg-open', [task.outputPath!]);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not open the directory: $e');
    }
  }

  Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.running:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.failed:
        return Colors.red;
      case TaskStatus.paused:
        return Colors.orange;
      case TaskStatus.init:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.running:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.failed:
        return Icons.error;
      case TaskStatus.paused:
        return Icons.pause_circle_outline;
      case TaskStatus.init:
        return Icons.schedule;
    }
  }
}
