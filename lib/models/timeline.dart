// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/post.dart';

class Timeline {
  // private member
  final List<Post> _timeline = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  static final Timeline _instance = Timeline._internal();
  Timeline._internal();

  // public member
  factory Timeline() => _instance;

  List<Post> get timeline => _timeline;

  Future<List<Post>> getLikePost() async {
    return await _dbHelper.getLikedPosts();
  }

  Future<List<Post>> getBookmarkPost() async {
    return await _dbHelper.getBookmarkedPosts();
  }

  Future<List<Post>> getPostByAccountUUID(String uuid) async {
    return await _dbHelper.getPostsByAuthor(uuid);
  }

  Future<List<Post>> getPostByAccount(Account account) async {
    return await getPostByAccountUUID(account.accountUUID);
  }

  Future<List<Post>> getReplyPostByParentPostUUID(String uuid) async {
    return await _dbHelper.getReplies(uuid);
  }

  Future<List<Post>> getReplyPostByParentPost(Post post) async {
    return await getReplyPostByParentPostUUID(post.postUUID);
  }

  Future<void> addPost(Post post) async {
    _timeline.insert(0, post);
    await _dbHelper.insertPost(post);
  }

  Future<void> removePost(Post post) async {
    _timeline.removeWhere((p) => p.postUUID == post.postUUID);
    await _dbHelper.deletePost(post.postUUID);
  }

  Future<void> replyPost(Post reply, String parentUUID) async {
    reply.parentPostUUID = parentUUID;
    await addPost(reply);
  }

  Future<void> updateAuthorName(String uuid, String newName) async {
    for (var post in _timeline.where((p) => p.authorUUID == uuid)) {
      post.authorName = newName;
    }
    await _dbHelper.updateAuthorName(uuid, newName);
  }

    Future<void> loadPost({int limit = 40, int offset = 0}) async {
        final List<Post> dbPosts = await _dbHelper.getTimeline(
            limit: limit,
            offset: offset,
        );

    if (offset == 0) {
      _timeline.clear();
    }
    _timeline.addAll(dbPosts);
  }
}
