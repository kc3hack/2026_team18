// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/account_manager_provider.dart';
import 'package:mikata/providers/profile_image_provider.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/widgets/remove_post_dialog.dart';

part 'post_box_bottom_buttons.dart';

class PostBox extends HookConsumerWidget {
  const PostBox({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // ▼ アカウント情報と画像の取得 ▼
    final accountManager = ref.watch(accountManagerProvider).value;
    final authorAccount = accountManager?.getAccountByAccountUUID(
      post.authorUUID,
    );
    final isMe =
        authorAccount?.accountUUID ==
        ref.watch(userAccountProvider).value?.accountUUID;
    final profileImagePath = ref.watch(profileImageProvider).value;

    ImageProvider? avatarImage;
    if (isMe && profileImagePath != null) {
      avatarImage = FileImage(File(profileImagePath));
    }

    return InkWell(
      onTap: () {
        context.push(RoutePath.postDetail.path, extra: post);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ▼ アイコンの反映 ▼
            CircleAvatar(
              backgroundColor: colorScheme.surfaceContainerHighest,
              backgroundImage: avatarImage,
              child: avatarImage == null ? Text(post.authorName[0]) : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        post.authorName,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (authorAccount != null)
                        Text(
                          "@${authorAccount.accountID}",
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      const Spacer(),
                      InkWell(
                        onTap: () => RemovePostDialog.show(context, post),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    post.content,
                    style: textTheme.bodyLarge,
                    maxLines: null,
                    softWrap: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconWithLabel(
                        icon: Icons.chat_bubble_rounded,
                        label: post.replyCount.toString(),
                      ),
                      IconWithLabel(
                        icon: Icons.favorite_rounded,
                        label: post.likeCount.toString(),
                      ),
                      IconWithLabel(
                        icon: Icons.bar_chart_rounded,
                        label: post.viewCount.toString(),
                      ),
                      Icon(
                        (post.isBookmark)
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: (post.isBookmark)
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
