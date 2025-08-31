import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/task_service.dart';
import 'package:web_cloner/widgets/task_form_dialog.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskService _taskService = Get.find<TaskService>();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Tasks: ${_tasks.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddTaskDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No tasks found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Click "Create Task" to start your first cloning task',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(task.status).withValues(alpha: 0.2),
                            child: Icon(
                              _getStatusIcon(task.status),
                              color: _getStatusColor(task.status),
                            ),
                          ),
                          title: Text(
                            task.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('URL: ${task.url}'),
                              Text('Type: ${task.type.toString().split('.').last}'),
                              Text(
                                'Progress: ${task.completedPages}/${task.totalPages} (${(task.progress * 100).toStringAsFixed(1)}%)',
                                style: const TextStyle(fontSize: 12),
                              ),
                              LinearProgressIndicator(
                                value: task.progress,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getStatusColor(task.status),
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (task.status == TaskStatus.pending)
                                IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () => _startTask(task),
                                  color: Colors.green,
                                ),
                              if (task.status == TaskStatus.running)
                                IconButton(
                                  icon: const Icon(Icons.pause),
                                  onPressed: () => _pauseTask(task),
                                  color: Colors.orange,
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditTaskDialog(task),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteTask(task),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
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
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.running:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.failed:
        return Icons.error;
      case TaskStatus.paused:
        return Icons.pause_circle;
    }
  }

  Future<void> _showAddTaskDialog() async {
    final result = await showDialog<Task>(
      context: context,
      builder: (context) => const TaskFormDialog(),
    );
    if (result != null) {
      await _taskService.addTask(result);
      _loadTasks();
    }
  }

  Future<void> _showEditTaskDialog(Task task) async {
    final result = await showDialog<Task>(
      context: context,
      builder: (context) => TaskFormDialog(task: task),
    );
    if (result != null) {
      await _taskService.updateTask(result);
      _loadTasks();
    }
  }

  Future<void> _startTask(Task task) async {
    await _taskService.startTask(task.id);
    _loadTasks();
  }

  Future<void> _pauseTask(Task task) async {
    await _taskService.pauseTask(task.id);
    _loadTasks();
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _taskService.deleteTask(task.id);
      _loadTasks();
    }
  }
}
