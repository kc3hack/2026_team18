// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/pages/post_detail_page/widgets/mini_icon_button.dart';
import 'package:mikata/providers/selected_post_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

part 'widgets/post_account_header.dart';
part 'widgets/post_content.dart';
part 'widgets/post_interaction_buttons.dart';

class PostDetailPage extends HookConsumerWidget {
  const PostDetailPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(selectedPostProvider);
    final replyListCount = post?.replyCount ?? 0;

    return Scaffold(
      appBar: CustomAppbar(title: const Text("投稿の詳細")),
      body: ListView.separated(
        itemCount: 1 + replyListCount,
        separatorBuilder: (context, index) {
          return const Divider(height: 24);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  PostAccountHeader(),
                  SizedBox(height: 12),
                  PostContent(),
                  Divider(height: 24),
                  PostInteractionButtons(),
                ],
              ),
            );
          }

          final replyIndex = index - 1;
          return PostBox(
            post: Post(
              authorUuid: "post_$replyIndex",
              authorName: "ユーザー$replyIndex",
              content: "これは投稿の内容です。投稿番号: $replyIndex",
              likeCount: replyIndex * 5,
              replyCount: replyIndex * 2,
              isBookmark: replyIndex % 2 == 0,
            ),
          );
        },
      ),
    );
  }
}
