// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PostBox', () {
    testWidgets('狭い幅でもはみ出さずに描画できる', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      final post = Post(
        postDate: DateTime.now().subtract(const Duration(days: 400)),
        authorName: 'とてもとてもとても長いユーザー名_ABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789',
        content:
            '本文がとても長いケースを想定して、折り返しが発生しても例外が出ないことを確認します。'
            'あいうえおかきくけこさしすせそたちつてと'
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
            '本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文',
        replyCount: 123,
        likeCount: 4567,
        viewCount: 89012,
        isBookmark: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: PostBox(post: post)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // RenderFlex overflow などが起きると FlutterError が例外として拾える。
      expect(tester.takeException(), isNull);
      expect(find.textContaining('とてもとてもとても長いユーザー名'), findsOneWidget);
      expect(find.textContaining('本文がとても長いケースを想定して'), findsOneWidget);
    });
  });
}
