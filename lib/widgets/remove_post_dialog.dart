// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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
      title: Text("投稿を削除"),
      content: Text("この投稿を削除してもよろしいですか？"),
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
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("キャンセル"),
        ),
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
