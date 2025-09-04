import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/account.dart';
import 'package:web_cloner/services/account_service.dart';
import 'package:web_cloner/services/brower_service.dart';
import 'package:web_cloner/services/logger.dart';
import 'package:web_cloner/widgets/account_form_dialog.dart';
import 'package:web_cloner/l10n/app_localizations.dart';

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

  Future<void> login(Account account) async {
    final l10n = AppLocalizations.of(Get.context!)!;
    BrowserSession? session;
    try {
      session = await BrowerService.instance.runBrowserWithPage(
        url: account.url,
        forceShowBrowser: true,
      );

      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text(l10n.loginProcess),
          content: Text( l10n.loginProcessHint),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: Text(l10n.saveCookies),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      if (confirmed == true) {
        final cookies = await session.lastPage().page.cookies();
        if (cookies.isNotEmpty) {
          account.cookies = cookies;
          await _accountService.updateAccount(account);
          Get.snackbar('Success', 'Cookies saved successfully!');
        } else {
          Get.snackbar('Warning', 'No cookies were captured.');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to open browser or save cookies: $e');
      logger.error('Login failed for account ${account.name}', error: e);
    } finally {
      await session?.close();
      loadAccounts();
    }
  }

  Future<void> deleteAccount(Account account) async {
    final l10n = AppLocalizations.of(Get.context!)!;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.areYouSureYouWantToDelete(account.name)),
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
