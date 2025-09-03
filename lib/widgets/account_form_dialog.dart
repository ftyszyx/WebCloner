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
      title: Text(account == null ? l10n.addAccount : l10n.editAccount),
      content: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: l10n.accountName,
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
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
