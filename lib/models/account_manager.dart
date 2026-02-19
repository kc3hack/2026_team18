import 'package:mikata/models/account.dart';
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/post.dart';

class AccountManager {
// public member
// private member
    static final AccountManager _instance = AccountManager._internal();
    final List<Account> _accountList = [];
    final DatabaseHelper _dbHelper = DatabaseHelper();

// public method
    factory AccountManager() => _instance;

    List<Account> get userList => _accountList;

    void addAccount(Account account) {
        _accountList.add(account);
    }

    void removeAccount(Account account) {
        _accountList.remove(account);
    }

    List<Account> getAllAccount() {
        return _accountList;
    }

    UserAccount? getUserAccount() {
        try {
            return _accountList.whereType<UserAccount>().first;
        } catch (e) {
            return null;
        }
    }

    List<BotAccount> getBotAccount() {
        return _accountList.whereType<BotAccount>().toList();
    }

    List<Account> getAccountByAccountName(String name) {
        return _accountList.where((i) => i.accountName == name).toList();
    }

    List<Account> getAccountByAccountID(String id) {
        return _accountList.where((i) => i.accountID == id).toList();
    }

    Account? getAccountByAccountUUID(String uuid) {
        for (Account i in _accountList) {
            if (i.accountUUID == uuid) return i;
        }

        return null;
    }

    Account? getAuthorAccountByPost(Post post) {
        final results = _accountList.where((i) => i.accountUUID == post.authorUUID);
        return results.isNotEmpty ? results.first : null;
    }
    
// private method
    AccountManager._internal();

    Future<void> loadAccounts() async {
        List<Account> accounts = await _dbHelper.getAllAccount();
        for (Account i in accounts) {
            _accountList.add(i);
        }
    }
}