// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/account_manager.dart';
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/gemini_api.dart';
import 'package:mikata/models/post.dart';

class Timeline {
  // private member
  final List<Post> _timeline = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  //   List<Post> Function()? apiCallback;
  late GeminiApi _geminiApi;

  static final Timeline _instance = Timeline._internal();
  Timeline._internal();

  // public member
  factory Timeline() => _instance;

  List<Post> get timeline => _timeline;

  GeminiApi get geminiApi => _geminiApi;

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

  Future<List<Post>> addPost(Post post) async {
    _insertPost(post: post);
    List<BotAccount> replyBots = AccountManager().getReplyBotAccounts();
    final List<Post> replyPosts = [];
    for (BotAccount i in replyBots) {
      final prompt =
          '''
            ロール: SNS投稿に対してリプライを100字以内に返す
            ${i.prompt}
            投稿 : ${post.content}
            ''';
      final replyContent = "test"; //await geminiApi.generateResponse(prompt);
      if (replyContent == null) continue;
      final replyPost = Post(
        authorName: i.accountName,
        authorUUID: i.accountUUID,
        content: replyContent,
      );

      await this.replyPost(replyPost, post.authorUUID);
      replyPosts.add(replyPost);
    }

    return replyPosts;
  }

  Future<void> removePost(Post post) async {
    _timeline.removeWhere((p) => p.postUUID == post.postUUID);
    await _dbHelper.deletePost(post.postUUID);
  }

  Future<void> replyPost(Post reply, String parentUUID) async {
    reply.parentPostUUID = parentUUID;
    await _insertPost(post: reply, insertPos: 1);
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

    // 追加: データベースが空の場合、Botに初期投稿を生成させる
    if (dbPosts.isEmpty && offset == 0) {
      await _insertInitialPosts();
      final newPosts = await _dbHelper.getTimeline(limit: limit, offset: offset);
      _timeline.clear();
      _timeline.addAll(newPosts);
    }

    else if (offset == 0) {
      _timeline.clear();
      _timeline.addAll(dbPosts);
    } else {
      final existingIds = _timeline.map((p) => p.postUUID).toSet();
      final newPosts = dbPosts
          .where((p) => !existingIds.contains(p.postUUID))
          .toList();

      _timeline.addAll(newPosts);
    }
  }

  void unloadPost({int limit = 40, int offset = 0}) {
    timeline.removeRange(offset, offset + limit);
  }

  void setGeminiAPI(GeminiApi geminiApi) {
    _geminiApi = geminiApi;
  }

  //private method
  Future<void> _insertPost({required Post post, int insertPos = 0}) async {
    _timeline.insert(insertPos, post);
    await _dbHelper.insertPost(post);
  }

  Future<void> _insertInitialPosts() async {
    final bots = AccountManager().getBotAccounts();
    if (bots.isEmpty) return;
    
    // 全Botの中からランダムに5体を抽出
    final shuffledBots = List<BotAccount>.from(bots)..shuffle();
    final initialBots = shuffledBots.take(5).toList(); 

    // リアリティのある適当な投稿内容
    final bodies = ['今日からこのアプリはじめました！', 'いい天気だね〜', 'お昼ごはん何食べようかな', 'みんなよろしく！', 'ホットリロード最高'];
    
    for (int i = 0; i < initialBots.length; i++) {
      final bot = initialBots[i];
      final post = Post(
        authorName: bot.accountName,
        authorUUID: bot.accountUUID,
        content: bodies[i % bodies.length],
        // 時間を少しずつズラすことで、タイムラインの並びを自然にする
        postDate: DateTime.now().subtract(Duration(minutes: (5 - i) * 10)),
      );
      await _dbHelper.insertPost(post);
    }
  }
}
