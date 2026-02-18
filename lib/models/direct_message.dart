class DirectMessage {
// private member
    String _userName;
    String _userID;
    final String _userUUID;
    final DateTime _dateTime;
    final String _content;

// public method
    DirectMessage({
        required String userName,
        required String userID,
        required String userUUID,
        DateTime? dateTime,
        required String content
    }) : _userName = userName,
        _userID    = userID,
        _userUUID  = userUUID,
        _dateTime  = dateTime ?? DateTime.now(),
        _content   = content;

    DirectMessage.fromJson(Map<String, dynamic> json) :
        _userName = json["userName"],
        _userID   = json["userID"],
        _userUUID = json["userUUID"],
        _dateTime = json["dateTime"],
        _content  = json["content"];

    Map<String, dynamic> toJson() => {
        "userName" : userName,
        "userID"   : userID,
        "userUUID" : userUUID,
        "dateTime" : dateTime,
        "content"  : content,
    };

    String get userName => _userName;
    set userName(String name) {
        if (name.isNotEmpty) _userName = name;
    }

    String get userID => _userID;
    set userID(String id) {
        if (id.isNotEmpty) _userID = id;   
    }

    String get userUUID => _userUUID;

    DateTime get dateTime => _dateTime;

    String get content => _content;
}