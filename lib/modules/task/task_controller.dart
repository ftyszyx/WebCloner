import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/task_service.dart';
import 'package:web_cloner/services/web_clone_service.dart';
import 'package:web_cloner/widgets/task_form_dialog.dart';

class TaskController extends GetxController {
  final TaskService _taskService = TaskService.instance;
  final WebCloneService _webCloneService = WebCloneService.instance;
  final tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks.value = await _taskService.getAllTasks();
  }

  Future<void> showAddTaskDialog() async {
    final result = await Get.dialog<Task>(const TaskFormDialog());
    if (result != null) {
      await _taskService.addTask(result);
      loadTasks();
    }
  }

  Future<void> showEditTaskDialog(Task task) async {
    final result = await Get.dialog<Task>(TaskFormDialog(task: task));
    if (result != null) {
      await _taskService.updateTask(result);
      loadTasks();
    }
  }

  Future<void> startTask(Task task) async {
    await _webCloneService.addTask(task);
    loadTasks(); // This might not immediately reflect running status
  }

  Future<void> pauseTask(Task task) async {
    await _taskService.pauseTask(task.id);
    loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.name}"?'),
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
      loadTasks();
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
