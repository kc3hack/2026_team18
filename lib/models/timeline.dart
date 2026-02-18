// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:mikata/models/file_utils.dart';
import 'package:mikata/models/post.dart';
import 'package:mikata/models/account.dart';

class Timeline {
// public member

// private member
    final List<Post> _timeline = [];
// public member
    Timeline();

    List<Post> get timeline => _timeline;

    List<Post> getLikePost() {
        return _timeline.where((i) => i.isLike).toList();
    }

    List<Post> getBookmarkPost() {
        return _timeline.where((i) => i.isBookmark).toList();
    }

    List<Post> getPostByAccountUUID(String uuid) {
        return _timeline.where((i) => i.authorUuid == uuid).toList();
    }

    List<Post> getPostByAccount(Account account) {
        return getPostByAccountUUID(account.accountUUID);
    }

    List<Post> getReplyPostByParentPostUUID(String uuid) {
        return _timeline.where((i) => i.parentPostUuid == uuid).toList();
    }

    List<Post> getReplyPostByParentPost(Post post) {
        return getReplyPostByParentPostUUID(post.parentPostUuid);
    }

    void addPost(Post post) {
        _timeline.add(post);
    }

    void removePost(Post post) {
        _timeline.remove(post);
    }

    void replyPost(Post reply, String parentUUID) {
        reply.parentPostUuid = parentUUID;
        addPost(reply);
    }

    void updateAuthorName(String uuid, String newName) {
        for (Post i in getPostByAccountUUID(uuid)) {
            i.authorName = newName;
        }
    }
// private member
    void loadPost() async {
        String? json = await FileIO().loadTextFile("post.json");
        if (json == null) return;
        List<dynamic> decodedList = jsonDecode(json);
        for (var i in decodedList.map((item) => Post.fromJson(item)).toList()) {
            _timeline.add(i);
        }

    }

    void savePost() async {
        final String content = jsonEncode([for(Post i in _timeline) i.toJson()]);
        await FileIO().saveFileAsString("post.json", content);
    }
}
