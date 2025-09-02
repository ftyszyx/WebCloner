import 'package:hive/hive.dart';
import 'package:web_cloner/models/task.dart';
import 'package:get/get.dart';

class TaskService {
  static TaskService get instance => Get.find<TaskService>();
  static const String _boxName = 'tasks';
  late Box<Task> _box;

  final RxList<Task> tasks = <Task>[].obs;

  Future<void> init() async {
    _box = await Hive.openBox<Task>(_boxName);
    _loadTasksFromBox();
    _box.watch().listen((event) {
      _loadTasksFromBox();
    });
  }

  void _loadTasksFromBox() {
    tasks.assignAll(_box.values.toList());
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
    await pauseTask(id);
    await _box.delete(id);
  }

  Future<void> pauseTask(String id) async {
    final task = await getTaskById(id);
    if (task != null) {
      task.status = TaskStatus.paused;
      await updateTask(task);
    }
  }

  Future<void> updateTaskStatus(String id, TaskStatus status) async {
    final task = await getTaskById(id);
    if (task != null) {
      task.status = status;
      await updateTask(task);
    }
  }

  Future<void> completeTask(
    String id,
    int total,
    int completed,
    int captured,
    String outputPath,
  ) async {
    final task = await getTaskById(id);
    if (task != null) {
      task.status = TaskStatus.completed;
      task.completedAt = DateTime.now();
      task.visitedNum = completed;
      task.totalPages = total;
      task.outputPath = outputPath;
      task.captureNum = captured;
      await updateTask(task);
    }
  }

  Future<void> updateTaskProgress(String id, int total, int captured,int visited) async {
    final task = await getTaskById(id);
    if (task != null) {
      task.totalPages = total;
      task.visitedNum = visited;
      task.captureNum = captured;
      await updateTask(task);
    }
  }

  Future<void> failTask(String id, String errorMessage) async {
    final task = await getTaskById(id);
    if (task != null) {
      task.status = TaskStatus.failed;
      task.errorMessage = errorMessage;
      await updateTask(task);
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
