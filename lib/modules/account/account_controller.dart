import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/account.dart';
import 'package:web_cloner/services/account_service.dart';
import 'package:web_cloner/widgets/account_form_dialog.dart';

class AccountController extends GetxController {
  final AccountService _accountService = AccountService.instance;
  final accounts = <Account>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    accounts.value = await _accountService.getAllAccounts();
  }

  Future<void> showAddAccountDialog() async {
    final result = await Get.dialog<Account>(const AccountFormDialog());
    if (result != null) {
      await _accountService.addAccount(result);
      loadAccounts();
    }
  }

  Future<void> showEditAccountDialog(Account account) async {
    final result = await Get.dialog<Account>(
      AccountFormDialog(account: account),
    );
    if (result != null) {
      await _accountService.updateAccount(result);
      loadAccounts();
    }
  }

  Future<void> deleteAccount(Account account) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete "${account.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _accountService.deleteAccount(account.id);
      loadAccounts();
    }
  }
}
