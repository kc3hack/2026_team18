// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/timeline_provider.dart';

class RemovePostDialog extends HookConsumerWidget {
  const RemovePostDialog({super.key, required this.post, this.routePath});

  final Post post;
  final RoutePath? routePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("投稿を削除")
          .animate()
          .fadeIn(duration: 160.ms)
          .slideY(duration: 200.ms, begin: 0.06, end: 0),
      content: Text("この投稿を削除してもよろしいですか？")
          .animate()
          .fadeIn(duration: 160.ms, delay: 60.ms)
          .slideY(duration: 200.ms, begin: 0.04, end: 0),
      actions: [
        FilledButton(
              onPressed: () {
                ref.read(timelineProvider.notifier)
                  ..removePost(post)
                  ..fetchTimeline();
                Navigator.of(context).pop();
                if (routePath != null) {
                  Navigator.of(context).pop();
                }
              },
              child: Text("削除"),
            )
            .animate()
            .fadeIn(duration: 160.ms, delay: 120.ms)
            .scale(
              duration: 200.ms,
              curve: Curves.easeOutBack,
              begin: const Offset(0.98, 0.98),
              end: const Offset(1, 1),
            ),
        TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("キャンセル"),
            )
            .animate()
            .fadeIn(duration: 160.ms, delay: 160.ms)
            .slideX(duration: 200.ms, begin: 0.04, end: 0),
      ],
    );
  }

  static void show(BuildContext context, Post post, [RoutePath? routePath]) {
    showDialog(
      context: context,
      builder: (context) => RemovePostDialog(post: post, routePath: routePath),
    );
  }
}
