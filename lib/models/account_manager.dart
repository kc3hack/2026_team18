import 'package:mikata/models/account.dart';
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/post.dart';

class AccountManager {
// public member
// private member
    static final AccountManager _instance = AccountManager._internal();
    final List<Account> _userList = [];
    final DatabaseHelper _dbHelper = DatabaseHelper();

// public method
    factory AccountManager() => _instance;

    List<Account> get userList => _userList;

    void addAccount(Account account) {
        _userList.add(account);
    }

    void removeAccount(Account account) {
        _userList.remove(account);
    }

    List<Account> getAllAccount() {
        return _userList;
    }

    UserAccount? getUserAccount() {
        try {
            return _userList.whereType<UserAccount>().first;
        } catch (e) {
            return null;
        }
    }

    List<BotAccount> getBotAccount() {
        return _userList.whereType<BotAccount>().toList();
    }

    List<Account> getAccountByAccountName(String name) {
        return _userList.where((i) => i.accountName == name).toList();
    }

    List<Account> getAccountByAccountID(String id) {
        return _userList.where((i) => i.accountID == id).toList();
    }

    List<Account> getAccountByAccountUUID(String uuid) {
        return _userList.where((i) => i.accountUUID == uuid).toList();
    }

    Account? getAuthorAccountByPost(Post post) {
        final results = _userList.where((i) => i.accountUUID == post.authorUUID);
        return results.isNotEmpty ? results.first : null;
    }
    
// private method
    AccountManager._internal();

    Future<void> loadAccounts() async {
        List<Account> accounts = await _dbHelper.getAllAccount();
        for (Account i in accounts) {
            _userList.add(i);
        }
    }
}