import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/models/account.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/account_service.dart';

class TaskFormDialog extends StatelessWidget {
  final Task? task;

  const TaskFormDialog({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_TaskFormDialogController(task));
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        task == null ? 'Create Task' : 'Edit Task',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Task Name',
                    prefixIcon: const Icon(Icons.label_outline),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
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
                  decoration: InputDecoration(
                    labelText: 'Website URL',
                    prefixIcon: const Icon(Icons.link),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
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
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.urlPatternController,
                  decoration: InputDecoration(
                    labelText: 'URL Pattern (use * as wildcard)',
                    prefixIcon: const Icon(Icons.pattern),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'e.g., /threads/*',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.captureUrlPatternController,
                  decoration: InputDecoration(
                    labelText: 'Capture URL Pattern (use * as wildcard)',
                    prefixIcon: const Icon(Icons.camera_alt),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'e.g., *.html or leave empty to capture all',
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ignore URL Patterns',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: controller.ignoreUrlPatterns
                              .map(
                                (pattern) => Chip(
                                  label: Text(pattern),
                                  onDeleted: () =>
                                      controller.removeIgnoreUrlPattern(pattern),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      TextFormField(
                        controller: controller.ignoreUrlPatternInputController,
                        decoration: InputDecoration(
                          hintText: 'Add a pattern and press Enter',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => controller.addIgnoreUrlPattern(),
                          ),
                        ),
                        onFieldSubmitted: (value) =>
                            controller.addIgnoreUrlPattern(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Allowed Domains',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: controller.domainList
                              .map(
                                (domain) => Chip(
                                  label: Text(domain),
                                  onDeleted: () =>
                                      controller.removeDomain(domain),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      TextFormField(
                        controller: controller.domainInputController,
                        decoration: InputDecoration(
                          hintText: 'Add a domain and press Enter',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => controller.addDomain(),
                          ),
                        ),
                        onFieldSubmitted: (value) => controller.addDomain(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.maxPagesController,
                  decoration: InputDecoration(
                    labelText: 'Max Pages',
                    prefixIcon: const Icon(Icons.filter_9_plus_outlined),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '0 for unlimited',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: controller.maxTaskNumController,
                  decoration: InputDecoration(
                    labelText: 'Max Concurrent Tasks',
                    prefixIcon: const Icon(Icons.sync_alt),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Leave empty for default',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Obx(
                  () => DropdownButtonFormField<String>(
                    initialValue: controller.selectedAccountId.value,
                    decoration: InputDecoration(
                      labelText: 'Account (for cookies)',
                      prefixIcon: const Icon(Icons.account_circle_outlined),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: controller.accounts
                        .map(
                          (account) => DropdownMenuItem(
                            value: account.id,
                            child: Text(account.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.selectedAccountId.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
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
  final urlPatternController = TextEditingController();
  final captureUrlPatternController = TextEditingController();
  final domainInputController = TextEditingController();
  final ignoreUrlPatternInputController = TextEditingController();
  final maxPagesController = TextEditingController();
  final maxTaskNumController = TextEditingController();

  final domainList = <String>[].obs;
  final ignoreUrlPatterns = <String>[].obs;
  final accounts = <Account>[].obs;
  final selectedAccountId = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadAccounts();
    if (task != null) {
      nameController.text = task!.name;
      urlController.text = task!.url;
      urlPatternController.text = task!.urlPattern ?? '';
      captureUrlPatternController.text = task!.captureUrlPattern ?? '';
      domainList.assignAll(task!.domainList);
      if (task!.ignoreUrlPatterns != null) {
        ignoreUrlPatterns.assignAll(task!.ignoreUrlPatterns!);
      }
      maxPagesController.text = task!.maxPages.toString();
      maxTaskNumController.text = task!.maxTaskNum?.toString() ?? '';
      selectedAccountId.value = task!.accountId;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    urlController.dispose();
    urlPatternController.dispose();
    captureUrlPatternController.dispose();
    domainInputController.dispose();
    ignoreUrlPatternInputController.dispose();
    maxPagesController.dispose();
    maxTaskNumController.dispose();
    super.onClose();
  }

  Future<void> _loadAccounts() async {
    accounts.value = await AccountService.instance.getAllAccounts();
  }

  void addDomain() {
    final domain = domainInputController.text.trim();
    if (domain.isNotEmpty && !domainList.contains(domain)) {
      domainList.add(domain);
      domainInputController.clear();
    }
  }

  void removeDomain(String domain) {
    domainList.remove(domain);
  }

  void addIgnoreUrlPattern() {
    final pattern = ignoreUrlPatternInputController.text.trim();
    if (pattern.isNotEmpty && !ignoreUrlPatterns.contains(pattern)) {
      ignoreUrlPatterns.add(pattern);
      ignoreUrlPatternInputController.clear();
    }
  }

  void removeIgnoreUrlPattern(String pattern) {
    ignoreUrlPatterns.remove(pattern);
  }

  void saveTask() {
    if (formKey.currentState!.validate()) {
      final newTask = Task(
        id: task?.id ?? const Uuid().v4(),
        name: nameController.text,
        url: urlController.text,
        urlPattern: urlPatternController.text,
        captureUrlPattern: captureUrlPatternController.text,
        domainList: domainList.toList(),
        ignoreUrlPatterns: ignoreUrlPatterns.toList(),
        createdAt: task?.createdAt ?? DateTime.now(),
        maxPages: int.tryParse(maxPagesController.text) ?? 0,
        maxTaskNum: int.tryParse(maxTaskNumController.text),
        accountId: selectedAccountId.value,
      );
      Get.back(result: newTask);
    }
  }
}
