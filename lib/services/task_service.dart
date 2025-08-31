import 'package:hive/hive.dart';
import 'package:web_cloner/models/task.dart';

class TaskService {
  static const String _boxName = 'tasks';
  late Box<Task> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Task>(_boxName);
  }

  Future<List<Task>> getAllTasks() async {
    return _box.values.toList();
  }

  Future<Task?> getTaskById(String id) async {
    return _box.get(id);
  }

  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  Future<void> startTask(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        status: TaskStatus.running,
        startedAt: DateTime.now(),
      );
      await updateTask(updatedTask);
    }
  }

  Future<void> pauseTask(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        status: TaskStatus.paused,
      );
      await updateTask(updatedTask);
    }
  }

  Future<void> completeTask(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
        completedPages: task.totalPages,
      );
      await updateTask(updatedTask);
    }
  }

  Future<void> failTask(String id, String errorMessage) async {
    final task = await getTaskById(id);
    if (task != null) {
      final updatedTask = task.copyWith(
        status: TaskStatus.failed,
        errorMessage: errorMessage,
      );
      await updateTask(updatedTask);
    }
  }

  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    return _box.values.where((task) => task.status == status).toList();
  }

  Future<List<Task>> getRunningTasks() async {
    return getTasksByStatus(TaskStatus.running);
  }

  void dispose() {
    _box.close();
  }
}
