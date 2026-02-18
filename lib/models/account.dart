import 'package:mikata/models/direct_message.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

String createUserID({int length = 8}) {
    const String charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    final Random random = Random.secure();
    final String randomStr =  List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    return randomStr;
}

class Account {
// protected member
    String _userName;
    String _userID;
    final String _userUUID;

// public method
    Account({
        required String userName,
        String? userID,
        String? userUUID
    }) : _userName = userName,
        _userID    = userID ?? createUserID(),
        _userUUID  = userUUID ?? Uuid().v4();

    String get userName => _userName;
    set userName(String name) {
        if (name.isNotEmpty) _userName = name;
    }

    String get userID => _userID;
    set userID(String id) {
        if (id.isNotEmpty) _userID = id;
    }

    String get userUUID => _userUUID;
}

class UserAccount extends Account {
// public member
    final Set<String> follow = {}; // userUUID
    final Set<String> follower = {}; // userUUID

// public method
    UserAccount({
        required super.userName,
        super.userID,
        super.userUUID
    });
}

class BotAccount extends Account {
// private member
    final List<DirectMessage> _dmLists = [];

// public method
    BotAccount({
        required super.userName,
        super.userID,
        super.userUUID
    });

    void addDM(DirectMessage dm) {
        _dmLists.add(dm);
    }

    void removeDM(DirectMessage dm) {
        _dmLists.remove(dm);
    }
}