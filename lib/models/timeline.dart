// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:mikata/models/file_utils.dart';
import 'package:mikata/models/post.dart';

class Timeline {
// public member

// private member
    final List<Post> _timeline = [];
// public member
    Timeline();

    List<Post> get timeline => _timeline;

    List<Post> getLikePost() {
        final List<Post> result = _timeline.where((i) => i.isLike).toList();
        return result;
    }

    List<Post> getBookmarkPost() {
        final List<Post> result = _timeline.where((i) => i.isBookmark).toList();
        return result;
    }

    void addPost(Post post) {
        _timeline.add(post);
    }

    void removePost(Post post) {
        _timeline.remove(post);
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
