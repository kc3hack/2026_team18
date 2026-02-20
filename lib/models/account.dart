// Dart imports:
import 'dart:math';

// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/direct_message.dart';
import 'package:mikata/models/timeline.dart';

enum Personality {
    praise("Praise"),
    empathy("Empathy"),
    criticism("Criticism");

    const Personality(this.name);
    final String name;
}

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

    void changeAccountName(String newName) {
        final Timeline timeline = Timeline();
        if (newName.isEmpty) return;
        _accountName = newName;
        timeline.updateAuthorName(accountUUID, newName); 
    }

    void changeAccountID(String newID) {
        if (newID.length == 8) {
            _accountID = newID;
        }
        _dbHelper.updateAccountID(accountUUID, _accountID);
    }

    String get accountID => _accountID;
    set accountID(String id) {
        if (id.isNotEmpty) _accountID = id;
    }

    String get accountUUID => _accountUUID;

    Map<String, dynamic> toMap() {
        final Map<String, dynamic> map = {
            'account_uuid': accountUUID,
            'account_name': accountName,
            'account_id'  : accountID,
            'account_type': this is UserAccount ? 0 : 1,
        };

        if (this is BotAccount) {
            final bot = this as BotAccount;
            map['personality'] = bot.personality;
            map['prompt']      = bot.prompt;
        }

        return map;
    }

    factory Account.fromMap(Map<String, dynamic> map) {
        if (map['account_type'] == 0) {
            return UserAccount(
                accountName: map['account_name'],
                accountID:   map['account_id'],
                accountUUID: map['account_uuid'],
            );
        } else {
            return BotAccount(
                accountName: map['account_name'],
                accountID:   map['account_id'],
                accountUUID: map['account_uuid'],
                personality: Personality.values.byName(map['personality']),
                prompt:      map['prompt'],
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
    final Personality _personality;
    final String _prompt;

// public method
    BotAccount({
        required super.accountName,
        super.accountID,
        super.accountUUID,
        required Personality personality,
        required String prompt
    }) : _personality = personality,
        _prompt       = prompt;

    Future<void> loadDMs() async {
        List<DirectMessage> dmList = await _dbHelper.getDirectMessagesByBotUUID(accountUUID);
        dmList.addAll(dmList);
    }

    Future<void> addDM(DirectMessage dm) async{
        _appendDM(dm);
        final prompt_ = '''
            ロール: SNSのDMに対しての返事を返す
            $_prompt
            投稿 : ${dm.content}
            ''';
        final content = "test";//await Timeline().geminiApi.generateResponse(prompt_);
        if (content == null) return;
        final directMessage = DirectMessage(botUUID: accountUUID, accountName: accountName, accountUUID: accountUUID, content: content);
        _appendDM(directMessage);
    }


    Future<void> removeDM(DirectMessage dm) async {
        _dmLists.remove(dm);
        await _dbHelper.deleteDirectMessage(dm.dmUUID);
    }

    List<DirectMessage> getDMs() {
        return _dmLists;
    }

    String get personality => _personality.name;

    String get prompt => _prompt;

//private method
    Future<void> _appendDM(DirectMessage dm) async {
        _dmLists.add(dm);
        await _dbHelper.insertDirectMessage(dm);
    }

}
