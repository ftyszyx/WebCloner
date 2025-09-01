import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:web_cloner/models/account.dart';

class AccountService {
  static AccountService get instance => Get.find<AccountService>();
  static const String _boxName = 'accounts';
  late Box<Account> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Account>(_boxName);
  }

  Future<List<Account>> getAllAccounts() async {
    return _box.values.toList();
  }

  Future<Account?> getAccountById(String id) async {
    return _box.get(id);
  }

  Future<void> addAccount(Account account) async {
    await _box.put(account.id, account);
  }

  Future<void> updateAccount(Account account) async {
    await _box.put(account.id, account);
  }

  Future<void> deleteAccount(String id) async {
    await _box.delete(id);
  }

  void dispose() {
    _box.close();
  }
}
