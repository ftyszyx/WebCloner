import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/models/account.dart';

class AccountFormDialog extends StatelessWidget {
  final Account? account;

  const AccountFormDialog({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(_AccountFormDialogController(account));
    return AlertDialog(
      title: Text(account == null ? 'Add Account' : 'Edit Account'),
      content: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.platformController,
                decoration: const InputDecoration(
                  labelText: 'Platform',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter platform';
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
          onPressed: () => controller.saveAccount(),
          child: Text(account == null ? 'Add' : 'Save'),
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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final platformController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (account != null) {
      nameController.text = account!.name;
      usernameController.text = account!.name;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    platformController.dispose();
    super.onClose();
  }

  void saveAccount() {
    if (formKey.currentState!.validate()) {
      final newAccount = Account(
        id: account?.id ?? const Uuid().v4(),
        name: nameController.text,
        createdAt: account?.createdAt ?? DateTime.now(),
      );
      Get.back(result: newAccount);
    }
  }
}
