// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:uuid/uuid.dart';

class Post {
// punlic member

// private member
    final DateTime _postDate;
    final String _authorName;
    final String _authorUuid;
    final String _content;
    final String _parentPostUuid;

    int _replyCount;
    int _likeCount;
    int _viewCount;

    bool _isLike;
    bool _isBookmark;
    String _relativeTime;

// public method
    Post ({
        DateTime? postDate,
        String authorName = "",
        String? authorUuid,
        String content = "",
        String parentPostUuid = "",
        int replyCount = 0,
        int likeCount = 0,
        int viewCount = 0,
        bool isLike = false,
        bool isBookmark = false,
        String relativeTime = ""
    }) : _postDate    = postDate ?? DateTime.now(),
        _authorName   = authorName,
        _authorUuid   = authorUuid ?? Uuid().v4(),
        _content      = content,
        _parentPostUuid   = parentPostUuid,
        _replyCount   = replyCount,
        _likeCount    = likeCount,
        _viewCount    = viewCount,
        _isLike       = isLike,
        _isBookmark   = isBookmark,
        _relativeTime = relativeTime 
    {
        _formatRelativeTime();
    }

    Post.fromJson(Map<String, dynamic> json) : 
        _postDate       = DateTime.parse(json["postDate"]),
        _authorName     = json["authorName"],
        _authorUuid     = json["authorUuid"],
        _content        = json["content"],
        _parentPostUuid = json["parentPostUuid"],
        _replyCount     = json["replyCount"],
        _likeCount      = json["likeCount"],
        _viewCount      = json["viewCount"],
        _isLike         = json["isLike"],
        _isBookmark     = json["isBookmark"],
        _relativeTime   = json["relativeTime"]
    {
        _formatRelativeTime();
    }

    Map<String, dynamic> toJson() => {
        "postDate"       : postDate,
        "authorName"     : authorName,
        "authorUuid"     : authorUuid,
        "content"        : content,
        "parentPostUuid" : parentPostUuid,
        "replyCount"     : replyCount,
        "likeCount"      : likeCount,
        "viewCount"      : viewCount,
        "isLike"         : isLike,
        "isBookmark"     : isBookmark,
        "relativeTime"   : relativeTime,
    };

    DateTime get postDate => _postDate;

    String get content => _content;

    String get relativeTime => _relativeTime;

    String get authorName => _authorName;

    String get authorUuid => _authorUuid;

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

    String get parentPostUuid => _parentPostUuid;
    set parentPostUuid(String uuid) {
        if (parentPostUuid == "") {
            parentPostUuid = uuid;
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
