// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/post.dart';

part 'post_box_bottom_buttons.dart';

class PostBox extends HookConsumerWidget {
  const PostBox({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
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
                Wrap(
                  spacing: 4,
                  runSpacing: 0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      post.user.userName,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      softWrap: true,
                    ),
                    Text(
                      "@userID・${post.relativeTime}",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  post.body,
                  style: textTheme.bodyLarge,
                  maxLines: null,
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconWithLabel(
                      icon: Icons.comment_rounded,
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
    );
  }
}
