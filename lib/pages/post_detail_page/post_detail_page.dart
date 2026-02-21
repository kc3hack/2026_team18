// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/pages/post_detail_page/widgets/mini_icon_button.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/timeline_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
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
                          PostAccountHeader(post: post)
                              .animate()
                              .fadeIn(duration: 200.ms)
                              .slideY(
                                duration: 240.ms,
                                begin: 0.06,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                          SizedBox(height: 12),
                          PostContent(post: post)
                              .animate()
                              .fadeIn(duration: 200.ms, delay: 60.ms)
                              .slideY(
                                duration: 240.ms,
                                begin: 0.05,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                          Divider(height: 24),
                          PostInteractionButtons(post: post)
                              .animate()
                              .fadeIn(duration: 200.ms, delay: 120.ms)
                              .slideY(
                                duration: 240.ms,
                                begin: 0.05,
                                end: 0,
                                curve: Curves.easeOutCubic,
                              ),
                        ],
                      ),
                    );
                  }

                  final replyIndex = index - 1;
                  final replyPost = replyList[replyIndex];
                  return PostBox(post: replyPost)
                      .animate(key: ValueKey(replyPost.postUUID))
                      .fadeIn(
                        duration: 220.ms,
                        delay: (50 * replyIndex).ms,
                        curve: Curves.easeOut,
                      )
                      .slideY(
                        duration: 260.ms,
                        begin: 0.06,
                        end: 0,
                        curve: Curves.easeOutCubic,
                      );
                },
              ),
            ),
            ReplySheet(parentPostUUID: post.postUUID)
                .animate()
                .fadeIn(duration: 220.ms, delay: 80.ms)
                .slideY(
                  duration: 260.ms,
                  begin: 0.2,
                  end: 0,
                  curve: Curves.easeOutCubic,
                ),
          ],
        ),
      ),
    );
  }
}
