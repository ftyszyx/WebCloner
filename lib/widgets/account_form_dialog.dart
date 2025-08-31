import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:web_cloner/models/account.dart';

class AccountFormDialog extends StatefulWidget {
  final Account? account;

  const AccountFormDialog({super.key, this.account});

  @override
  State<AccountFormDialog> createState() => _AccountFormDialogState();
}

class _AccountFormDialogState extends State<AccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _platformController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _nameController.text = widget.account!.name;
      _usernameController.text = widget.account!.username;
      _passwordController.text = widget.account!.password;
      _platformController.text = widget.account!.platform;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _platformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.account == null ? 'Add Account' : 'Edit Account'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
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
                controller: _usernameController,
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
                controller: _passwordController,
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
                controller: _platformController,
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAccount,
          child: Text(widget.account == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final account = Account(
        id: widget.account?.id ?? const Uuid().v4(),
        name: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        platform: _platformController.text,
        createdAt: widget.account?.createdAt ?? DateTime.now(),
        lastLoginAt: widget.account?.lastLoginAt,
        isActive: widget.account?.isActive ?? true,
      );
      Navigator.of(context).pop(account);
    }
  }
}
