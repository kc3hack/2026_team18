// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/widgets/remove_post_dialog.dart';

part 'post_box_bottom_buttons.dart';

class PostBox extends HookConsumerWidget {
  const PostBox({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        context.push(RoutePath.postDetail.path, extra: post);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(),
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
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "@userID・${post.relativeTime}",
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          RemovePostDialog.show(context, post);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
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
