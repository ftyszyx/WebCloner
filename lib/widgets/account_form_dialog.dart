import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/l10n/app_localizations.dart';
import 'package:web_cloner/models/account.dart';

class AccountFormDialog extends StatelessWidget {
  final Account? account;

  const AccountFormDialog({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AccountFormDialogController(account));
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        account == null ? l10n.addAccount : l10n.editAccount,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: l10n.accountName,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.accountNameRequired;
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
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'https://example.com',
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
            ],
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
          onPressed: () => controller.saveAccount(),
          child: Text(account == null ? l10n.addAccount : l10n.save),
        ),
      ],
    );
  }
}

class _AccountFormDialogController extends GetxController {
  final Account? account;
  _AccountFormDialogController(this.account);

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final urlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (account != null) {
      nameController.text = account!.name;
      urlController.text = account!.url;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    urlController.dispose();
    super.onClose();
  }

  void saveAccount() {
    if (formKey.currentState!.validate()) {
      final newAccount = Account(
        id: account?.id ?? const Uuid().v4(),
        name: nameController.text,
        url: urlController.text,
        createdAt: account?.createdAt ?? DateTime.now(),
      );
      Get.back(result: newAccount);
    }
  }
}
