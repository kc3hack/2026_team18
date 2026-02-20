// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:mikata/models/account_manager.dart';

// Package imports:
import 'package:uuid/uuid.dart';

class Post {
  // punlic member

  // private member
  final DateTime _postDate;
  final String _postUUID;
  String _authorName;
  final String _authorUUID;
  final String _content;
  final String _parentPostUUID;

  int _replyCount;
  int _likeCount;
  int _viewCount;

  bool _isLike;
  bool _isBookmark;
  String _relativeTime;

  // public method
  Post({
    DateTime? postDate,
    String? postUUID,
    required String authorName,
    String? authorUUID,
    required String content,
    String parentPostUUID = "",
    int replyCount = 0,
    int likeCount = 0,
    int viewCount = 0,
    bool isLike = false,
    bool isBookmark = false,
    String relativeTime = "",
  }) : _postDate = postDate ?? DateTime.now(),
       _postUUID = postUUID ?? Uuid().v4(),
       _authorName = authorName,
       _authorUUID = authorUUID ?? Uuid().v4(),
       _content = content,
       _parentPostUUID = parentPostUUID,
       _replyCount = replyCount,
       _likeCount = likeCount,
       _viewCount = viewCount,
       _isLike = isLike,
       _isBookmark = isBookmark,
       _relativeTime = relativeTime {
    _formatRelativeTime();
  }

  Map<String, dynamic> toMap() => {
    "post_uuid": postUUID,
    "author_uuid": authorUUID,
    "post_date": postDate.millisecondsSinceEpoch,
    "content": content,
    "parent_post_uuid": parentPostUUID,
    "reply_count": replyCount,
    "like_count": likeCount,
    "view_count": viewCount,
    "is_like": isLike ? 1 : 0,
    "is_bookmark": isBookmark ? 1 : 0,
  };

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postUUID: map["post_uuid"],
      postDate: DateTime.fromMillisecondsSinceEpoch(map["post_date"]),
      authorName: AccountManager().getAccountByAccountUUID(map["author_uuid"])?.accountName ?? "Unknown",
      authorUUID: map["author_uuid"],
      content: map["content"],
      parentPostUUID: map["parent_post_uuid"],
      replyCount: map["reply_count"],
      likeCount: map["like_count"],
      viewCount: map["view_count"],
      isLike: map["is_like"] == 1,
      isBookmark: map["is_bookmark"] == 1,
    );
  }

  DateTime get postDate => _postDate;

  String get postUUID => _postUUID;

  String get content => _content;

  String get relativeTime => _relativeTime;

  String get authorUUID => _authorUUID;

  String get authorName => _authorName;
  set authorName(String name) {
    if (name.isNotEmpty) _authorName = name;
  }

  int get replyCount => _replyCount;
  set replyCount(int value) {
    if (value < 0) {
      debugPrint("Cannot be set to less than 0");
      return;
    }
    _replyCount = value;
  }

  int get likeCount => _likeCount;
  set likeCount(int value) {
    if (value < 0) {
      debugPrint("Cannot be set to less than 0");
      return;
    }
    _likeCount = value;
  }

  int get viewCount => _viewCount;
  set viewCount(int value) {
    if (value < 0) {
      debugPrint("Cannot be set to less than 0");
      return;
    }
    _viewCount = value;
  }

  String get parentPostUUID => _parentPostUUID;
  set parentPostUUID(String uuid) {
    if (parentPostUUID == "") {
      parentPostUUID = uuid;
    }
  }

  bool get isLike => _isLike;
  void toggleLike() {
    _isLike = !_isLike;
  }

  bool get isBookmark => _isBookmark;
  void toggleBookmark() {
    _isBookmark = !_isBookmark;
  }

  // private method
  void _formatRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inSeconds < 60) {
      _relativeTime = 'たった今';
    } else if (difference.inMinutes < 60) {
      _relativeTime = '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      _relativeTime = '${difference.inHours}時間前';
    } else if (difference.inDays < 7) {
      _relativeTime = '${difference.inDays}日前';
    } else if (difference.inDays < 30) {
      _relativeTime = '${(difference.inDays / 7).floor()}週間前';
    } else if (difference.inDays < 365) {
      _relativeTime = '${(difference.inDays / 30).floor()}ヶ月前';
    } else {
      _relativeTime = '${(difference.inDays / 365).floor()}年前';
    }
  }
}