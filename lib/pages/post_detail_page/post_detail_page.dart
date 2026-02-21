// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/models/account.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/pages/post_detail_page/widgets/mini_icon_button.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/timeline_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/providers/account_manager_provider.dart';
import 'package:mikata/providers/profile_image_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';
import 'package:mikata/widgets/remove_post_dialog.dart';

part 'widgets/post_account_header.dart';
part 'widgets/post_content.dart';
part 'widgets/post_interaction_buttons.dart';
part 'widgets/reply_sheet.dart';

class PostDetailPage extends HookConsumerWidget {
  const PostDetailPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineProvider);
    final List<Post> replyList = timelineAsync.maybeWhen(
      data: (timeline) => timeline.timeline
          .where((p) => p.parentPostUUID == post.postUUID)
          .toList(),
      orElse: () => [],
    );

    return Scaffold(
      appBar: CustomAppbar(title: const Text("投稿の詳細")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: 1 + replyList.length,
                separatorBuilder: (context, index) {
                  return const Divider(height: 24);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          PostAccountHeader(post: post),
                          SizedBox(height: 12),
                          PostContent(post: post),
                          Divider(height: 24),
                          PostInteractionButtons(post: post),
                        ],
                      ),
                    );
                  }

                  final replyIndex = index - 1;
                  return PostBox(post: replyList[replyIndex]);
                },
              ),
            ),
            ReplySheet(parentPostUUID: post.postUUID),
          ],
        ),
      ),
    );
  }
}
