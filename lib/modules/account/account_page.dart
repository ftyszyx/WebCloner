import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/modules/account/account_controller.dart';
import 'package:web_cloner/l10n/app_localizations.dart';
import 'package:web_cloner/routes/app_pages.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.accountPageTitle),
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
                  child: Obx(
                    () => Text(
                      l10n.totalAccounts(controller.accounts.length),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => controller.showAddAccountDialog(),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addAccount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => controller.accounts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noAccounts,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.addAccountHint,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.accounts.length,
                      itemBuilder: (context, index) {
                        final account = controller.accounts[index];
                        final isLoggedIn =
                            account.cookies != null &&
                            account.cookies!.isNotEmpty;
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                account.name.isNotEmpty
                                    ? account.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              account.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.urlLabel(account.url)),
                                const SizedBox(height: 4),
                                Chip(
                                  label: Text(
                                    isLoggedIn
                                        ? l10n.loggedIn
                                        : l10n.notLoggedIn,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isLoggedIn
                                          ? Colors.green.shade800
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  backgroundColor: isLoggedIn
                                      ? Colors.green.shade100
                                      : Colors.grey.shade200,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 0,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.login,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () => controller.login(account),
                                  tooltip: l10n.loginAndSaveCookies,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      controller.showEditAccountDialog(account),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      controller.deleteAccount(account),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.logs),
        icon: const Icon(Icons.bug_report),
        label: const Text('Logs'),
      ),
    );
  }
}
