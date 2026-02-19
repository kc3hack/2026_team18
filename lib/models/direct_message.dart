class DirectMessage {
  // private member
  String _accountName;
  String _accountID;
  final String _accountUUID;
  final DateTime _dateTime;
  final String _content;

  // public method
  DirectMessage({
    required String accountName,
    required String accountID,
    required String accountUUID,
    DateTime? dateTime,
    required String content,
  }) : _accountName = accountName,
       _accountID = accountID,
       _accountUUID = accountUUID,
       _dateTime = dateTime ?? DateTime.now(),
       _content = content;

  DirectMessage.fromJson(Map<String, dynamic> json)
    : _accountName = json["accountName"],
      _accountID = json["accountID"],
      _accountUUID = json["accountUUID"],
      _dateTime = DateTime.parse(json["dateTime"]),
      _content = json["content"];

  Map<String, dynamic> toJson() => {
    "accountName": accountName,
    "accountID": accountID,
    "accountUUID": accountUUID,
    "dateTime": dateTime.toIso8601String(),
    "content": content,
  };

  String get accountName => _accountName;
  set accountName(String name) {
    if (name.isNotEmpty) _accountName = name;
  }

  String get accountID => _accountID;
  set accountID(String id) {
    if (id.isNotEmpty) _accountID = id;
  }

  String get accountUUID => _accountUUID;

  DateTime get dateTime => _dateTime;

  String get content => _content;
}
