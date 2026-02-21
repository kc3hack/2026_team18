// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/providers/timeline_provider.dart';

class BookmarkTab extends HookConsumerWidget {
  const BookmarkTab({super.key, required this.user});

  final UserAccount user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.read(timelineProvider);

    return timelineAsync.when(
      error: (error, stackTrace) => Center(child: Text("error $error")),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (timeline) {
        return FutureBuilder(
          future: timeline.getBookmarkPost(),
          builder: (context, asyncSnapshot) {
            final bookmarkPosts = asyncSnapshot.data ?? [];

            if (bookmarkPosts.isEmpty) {
              return const Center(child: Text("ブックマークした投稿がありません"));
            }

            return ListView.separated(
              itemCount: bookmarkPosts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return PostBox(post: bookmarkPosts[index]);
              },
            );
          },
        );
      },
    );
  }
}
