import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/account.dart';
import 'package:web_cloner/services/account_service.dart';
import 'package:web_cloner/widgets/account_form_dialog.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountService _accountService = Get.find<AccountService>();
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final accounts = await _accountService.getAllAccounts();
    setState(() {
      _accounts = accounts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
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
                  child: Text(
                    'Total Accounts: ${_accounts.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddAccountDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _accounts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No accounts found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Click "Add Account" to create your first account',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _accounts.length,
                    itemBuilder: (context, index) {
                      final account = _accounts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              account.name[0].toUpperCase(),
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
                              Text('Username: ${account.username}'),
                              Text('Platform: ${account.platform}'),
                              Text(
                                'Created: ${_formatDate(account.createdAt)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: account.isActive,
                                onChanged: (value) => _toggleAccountStatus(account, value),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEditAccountDialog(account),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteAccount(account),
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _showAddAccountDialog() async {
    final result = await showDialog<Account>(
      context: context,
      builder: (context) => const AccountFormDialog(),
    );
    if (result != null) {
      await _accountService.addAccount(result);
      _loadAccounts();
    }
  }

  Future<void> _showEditAccountDialog(Account account) async {
    final result = await showDialog<Account>(
      context: context,
      builder: (context) => AccountFormDialog(account: account),
    );
    if (result != null) {
      await _accountService.updateAccount(result);
      _loadAccounts();
    }
  }

  Future<void> _toggleAccountStatus(Account account, bool value) async {
    final updatedAccount = account.copyWith(isActive: value);
    await _accountService.updateAccount(updatedAccount);
    _loadAccounts();
  }

  Future<void> _deleteAccount(Account account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text('Are you sure you want to delete "${account.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _accountService.deleteAccount(account.id);
      _loadAccounts();
    }
  }
}
