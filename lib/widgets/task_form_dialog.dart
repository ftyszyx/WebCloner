import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/models/account.dart';
import 'package:web_cloner/models/task.dart';
import 'package:web_cloner/services/account_service.dart';
import 'package:web_cloner/l10n/app_localizations.dart';

class TaskFormDialog extends StatelessWidget {
  final Task? task;

  const TaskFormDialog({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_TaskFormDialogController(task));
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        task == null ? l10n.create : l10n.editTask,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.6),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7)),
            prefixIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
            ),
          ),
        ),
        child: SizedBox(
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
                      labelText: l10n.taskName,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.label_outline),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.taskNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.urlController,
                    decoration: InputDecoration(
                      labelText: l10n.websiteUrl,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.link),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'https://example.com',
                      helperText: l10n.urlRequired,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.urlRequired;
                      }
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.isAbsolute) {
                        return l10n.urlInvalid;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.urlPatternController,
                    decoration: InputDecoration(
                      labelText: l10n.urlPattern,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.pattern),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'e.g., /threads/*',
                      helperText: l10n.maxPagesHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.captureUrlPatternController,
                    decoration: InputDecoration(
                      labelText: l10n.captureUrlPattern,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.camera_alt),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: l10n.captureUrlPatternHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.rule, size: 18, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(l10n.ignoreUrlPatterns, style: Theme.of(context).textTheme.labelLarge),
                          ],
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
                                    deleteIcon: const Icon(Icons.close, size: 16),
                                    onDeleted: () => controller.removeIgnoreUrlPattern(pattern),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        TextFormField(
                          controller: controller.ignoreUrlPatternInputController,
                          decoration: InputDecoration(
                            hintText: l10n.addPatternHint,
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              tooltip: l10n.addPatternHint,
                              icon: const Icon(Icons.add),
                              onPressed: () => controller.addIgnoreUrlPattern(),
                            ),
                          ),
                          onFieldSubmitted: (value) => controller.addIgnoreUrlPattern(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.domain, size: 18, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(l10n.allowedDomains, style: Theme.of(context).textTheme.labelLarge),
                          ],
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
                                    deleteIcon: const Icon(Icons.close, size: 16),
                                    onDeleted: () => controller.removeDomain(domain),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        TextFormField(
                          controller: controller.domainInputController,
                          decoration: InputDecoration(
                            hintText: l10n.addDomainHint,
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              tooltip: l10n.addDomainHint,
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
                      labelText: l10n.maxPages,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.filter_9_plus_outlined),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '0 for unlimited',
                      helperText: l10n.maxPagesHint,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.maxTaskNumController,
                    decoration: InputDecoration(
                      labelText: l10n.maxConcurrentTasks,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: const Icon(Icons.sync_alt),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: l10n.maxConcurrentTasksHint,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => DropdownButtonFormField<String?>(
                      initialValue: controller.accounts.any((a) => a.id == controller.selectedAccountId.value) ? controller.selectedAccountId.value : null,
                      decoration: InputDecoration(
                        labelText: l10n.accountForCookies,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text(l10n.none)),
                        ...controller.accounts.map(
                          (account) => DropdownMenuItem(
                            value: account.id,
                            child: Text(account.name),
                          ),
                        ),
                      ],
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
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text(l10n.cancel)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => controller.saveTask(),
          child: Text(task == null ? l10n.create : l10n.save),
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
