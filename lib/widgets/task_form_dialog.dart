import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/models/task.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;

  const TaskFormDialog({super.key, this.task});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  TaskType _selectedType = TaskType.singlePage;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _nameController.text = widget.task!.name;
      _urlController.text = widget.task!.url;
      _selectedType = widget.task!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Website URL',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter website URL';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.hasAbsolutePath) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Clone Type',
                  border: OutlineInputBorder(),
                ),
                items: TaskType.values.map((type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(_getTaskTypeDisplayName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Clone Type Description:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_getTaskTypeDescription(_selectedType)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: Text(widget.task == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }

  String _getTaskTypeDisplayName(TaskType type) {
    switch (type) {
      case TaskType.singlePage:
        return 'Single Page';
      case TaskType.multiPage:
        return 'Multiple Pages';
      case TaskType.fullSite:
        return 'Full Website';
    }
  }

  String _getTaskTypeDescription(TaskType type) {
    switch (type) {
      case TaskType.singlePage:
        return 'Clone a single webpage and save as screenshot and HTML.';
      case TaskType.multiPage:
        return 'Clone multiple pages from the same website.';
      case TaskType.fullSite:
        return 'Crawl and clone the entire website structure.';
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        name: _nameController.text,
        url: _urlController.text,
        type: _selectedType,
        status: widget.task?.status ?? TaskStatus.pending,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        startedAt: widget.task?.startedAt,
        completedAt: widget.task?.completedAt,
        totalPages: widget.task?.totalPages ?? 0,
        completedPages: widget.task?.completedPages ?? 0,
        outputPath: widget.task?.outputPath,
        errorMessage: widget.task?.errorMessage,
        settings: widget.task?.settings,
      );
      Navigator.of(context).pop(task);
    }
  }
}
