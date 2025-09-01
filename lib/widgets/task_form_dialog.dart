import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/models/task.dart';

class TaskFormDialog extends StatelessWidget {
  final Task? task;

  const TaskFormDialog({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_TaskFormDialogController(task));
    return AlertDialog(
      title: Text(task == null ? 'Create Task' : 'Edit Task'),
      content: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
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
                controller: controller.urlController,
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
                  if (uri == null || !uri.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () => controller.saveTask(),
          child: Text(task == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }
}

class _TaskFormDialogController extends GetxController {
  final Task? task;
  _TaskFormDialogController(this.task);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final urlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (task != null) {
      nameController.text = task!.name;
      urlController.text = task!.url;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    urlController.dispose();
    super.onClose();
  }

  void saveTask() {
    if (formKey.currentState!.validate()) {
      final newTask = Task(
        id: task?.id ?? const Uuid().v4(),
        name: nameController.text,
        url: urlController.text,
        urlPattern: task?.urlPattern ?? '',
        domainList: task?.domainList ?? [],
        createdAt: task?.createdAt ?? DateTime.now(),
        maxPages: task?.maxPages ?? 0,
      );
      Get.back(result: newTask);
    }
  }
}
