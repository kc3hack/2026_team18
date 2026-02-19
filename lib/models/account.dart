// Dart imports:
import 'dart:math';

// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:mikata/models/direct_message.dart';
import 'package:mikata/models/timeline.dart';
import 'package:mikata/models/database_helper.dart';

String createAccountID({int length = 8}) {
    const String charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    final Random random = Random.secure();
    final String randomStr =  List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    return randomStr;
}

class Account {
// protected member
    String _accountName;
    String _accountID;
    final String _accountUUID;
    final DatabaseHelper _dbHelper = DatabaseHelper();

// public method
    Account({
        required String accountName,
        String? accountID,
        String? accountUUID
    }) : _accountName = accountName,
        _accountID    = accountID ?? createAccountID(),
        _accountUUID  = accountUUID ?? Uuid().v4();

    String get accountName => _accountName;

    void changeAccountName(String newName, Timeline timeline) {
        if (newName.isEmpty) return;
        _accountName = newName;
        timeline.updateAuthorName(accountUUID, newName); 
    }

    String get accountID => _accountID;
    set accountID(String id) {
        if (id.isNotEmpty) _accountID = id;
    }

    String get accountUUID => _accountUUID;

    Map<String, dynamic> toMap() {
        return {
            'account_uuid': accountUUID,
            'account_name': accountName,
            'account_id': accountID,
            'account_type': this is UserAccount ? 0 : 1,
        };
    }

    factory Account.fromMap(Map<String, dynamic> map) {
        if (map['account_type'] == 0) {
            return UserAccount(
                accountName: map['account_name'],
                accountID: map['account_id'],
                accountUUID: map['account_uuid'],
            );
        } else {
            return BotAccount(
                accountName: map['account_name'],
                accountID: map['account_id'],
                accountUUID: map['account_uuid'],
            );
        }
    }
}

class UserAccount extends Account {
// public member
    final Set<String> follow = {}; // accountUUID
    final Set<String> follower = {}; // accountUUID

// public method
    UserAccount({
        required super.accountName,
        super.accountID,
        super.accountUUID
    });
}

class BotAccount extends Account {
// private member
    final List<DirectMessage> _dmLists = [];

// public method
    BotAccount({
        required super.accountName,
        super.accountID,
        super.accountUUID
    });

    Future<void> loadDMs() async {
        List<DirectMessage> dmList = await _dbHelper.getDirectMessagesByBotUUID(accountUUID);
        dmList.addAll(dmList);
    }

    Future<void> addDM(DirectMessage dm) async{
        _dmLists.add(dm);
        await _dbHelper.insertDirectMessage(dm);
    }

    Future<void> removeDM(DirectMessage dm) async {
        _dmLists.remove(dm);
        await _dbHelper.deleteDirectMessage(dm.dmUUID);
    }

    List<DirectMessage> getDMs() {
        return _dmLists;
    }
}
