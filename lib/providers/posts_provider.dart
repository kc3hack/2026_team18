// Dart imports:
import 'dart:async';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/post.dart';

class PostNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    return _fetchPosts();
  }

  List<Post> getPosts() => _dummyPosts();

  Future<void> fetchPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPosts);
  }

  Future<List<Post>> _fetchPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    
    // 取得処理
    return _dummyPosts();
  }

  List<Post> _dummyPosts() {
    final users = <BotAccount>[
      BotAccount(userName: 'Alice'),
      BotAccount(userName: 'Bob'),
      BotAccount(userName: 'Carol'),
      BotAccount(userName: 'Dave'),
      BotAccount(userName: 'Eve'),
      BotAccount(userName: 'Frank'),
    ];

    final now = DateTime.now();
    final bodies = <String>[
      'はじめまして！',
      '今日の調子どう？',
      '朝ごはん何食べた？',
      '今日は集中できる日',
      'ホットリロード最高',
      'この画面、余白もう少し欲しい',
      '通知ってどのタイミングが良い？',
      'APIは後で繋ぐ予定（今はダミー）',
      'テスト書くの大事',
      'アイデア募集：投稿のカテゴリどうする？',
      '今日の目標：ひとつだけ終わらせる',
      '睡眠は大事。ほんとに',
      'デザイン詰めるの楽しい',
      'エラー出たけど原因わかった',
      'コミット前に整形した',
      '明日は早起きする（たぶん）',
      'ちょっと休憩',
      '進捗：順調',
      'このダミー投稿、もっと増やせる',
      '最後にもう一件！',
      '朝の電車が遅れてて、ホームでぼーっと空を見てた。コンビニのホットコーヒーが温かくて助かった。今日も無理せず、やることを一つだけ終わらせよう。帰りにスーパーで卵買う。',
    ];

    return List<Post>.generate(bodies.length, (index) {
      final user = users[index % users.length];
      final minutesAgo = (index + 1) * 7;

      return Post(
        authorName: user.userName,
        authorUuid: user.userUUID,
        content: bodies[index],
        replyCount: index % 4,
        likeCount: (index * 3) % 50,
        viewCount: (index * 17) % 300,
        isLike: index % 5 == 0,
        isBookmark: index % 7 == 0,
        postDate: now.subtract(Duration(minutes: minutesAgo)),
      );
    });
  }
}

final postsProvider =
    AsyncNotifierProvider.autoDispose<PostNotifier, List<Post>>(
      PostNotifier.new,
    );
