import 'package:flutter/foundation.dart';
import 'package:mikata/models/user.dart';

class Post {
// public member
	String body;

// private member
	final User _user;
	final DateTime _postDate;
	int _replyCount;
	int _likeCount;
	int _viewCount;
	bool _isLike;
	bool _isBookmark;
	String _relativeTime = "";
	final List<Post> _replyPost = [];

// public member
	Post({
		required User user,
		this.body       = "",
    	int replyCount  = 0,
    	int likeCount   = 0,
    	int viewCount   = 0,
    	bool isLike     = false,
    	bool isBookmark = false,
    	DateTime? postDate,
 	}) : _postDate  = postDate ?? DateTime.now(),
		_user       = user,
    	_replyCount = replyCount,
    	_likeCount  = likeCount,
    	_viewCount  = viewCount,
    	_isLike     = isLike,
    	_isBookmark = isBookmark;

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

	bool get isLike => _isLike;
	void toggleLike() {
		_isLike = !_isLike;
	}

	bool get isBookmark => _isBookmark;
	void toggleBookmark() {
		_isBookmark = !_isBookmark;
	}

	List<Post> get replyPost => _replyPost;
	void appendReply(Post reply) {
		_replyPost.add(reply);
		replyCount = _replyPost.length;
	}

	DateTime get postDate => _postDate;

	String get relativeTime => _relativeTime;

	User get user => _user;

// private member
	void formatRelativeTime() {
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