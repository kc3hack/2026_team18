// Package imports:
import 'package:uuid/uuid.dart';

class User {
// public member
    String userName;
    final String _userUuid;
// private member

//public method
    User({
        required this.userName,
        String? userUuid
    }) : _userUuid = userUuid ?? Uuid().v4();

    String get userUuid => _userUuid;

    User.fromJson(Map<String, dynamic> json) : 
        userName = json["userName"],
        _userUuid = json["useruuid"];

    Map<String, dynamic> toJson() => {
        "userName" : userName,
        "userUuid" : userUuid
    };
// private method
}
