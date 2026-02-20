// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:mikata/models/account_manager.dart';

class DirectMessage {
// private member
    String _botUUID;
    String _accountName;
    final String _accountUUID;
    final DateTime _dateTime;
    final String _content;
    final String _dmUUID;

// public method
    DirectMessage({
        required String botUUID,     // DM相手のBotAccount
        required String accountName, // DMの送り元
        required String accountUUID, // DMの送り元
        DateTime? dateTime,
        required String content,
        String? dmUUID
    }) : _botUUID    = botUUID,
        _accountName = accountName,
        _accountUUID = accountUUID,
        _dateTime    = dateTime ?? DateTime.now(),
        _content     = content,
        _dmUUID      = dmUUID ?? Uuid().v4();

    Map<String, dynamic> toMap() {
        return {
            'dm_uuid': _dmUUID,
            'bot_uuid': _botUUID,
            'from_account_uuid': _accountUUID,
            'content': _content,
            'date_time': _dateTime.millisecondsSinceEpoch,
        };
    }

    factory DirectMessage.fromMap(Map<String, dynamic> map) {
        return DirectMessage(
            dmUUID: map['dm_uuid'],
            botUUID: map['bot_uuid'],
            accountName: AccountManager().getAccountByAccountUUID(map['from_account_uuid'])!.accountName,
            accountUUID: map['from_account_uuid'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(map['date_time']),
            content: map['content'],
        );
    }

    String get accountName => _accountName;
    set accountName(String name) {
        if (name.isNotEmpty) _accountName = name;
    }

    String get accountUUID => _accountUUID;

    DateTime get dateTime => _dateTime;

    String get content => _content;

    String get dmUUID => _dmUUID;

    String get botUUID => _botUUID;
}
