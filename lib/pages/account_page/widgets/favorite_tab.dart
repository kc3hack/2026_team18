// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/providers/timeline_provider.dart';

class FavoriteTab extends HookConsumerWidget {
  const FavoriteTab({super.key, required this.user});

  final UserAccount user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.read(timelineProvider);

    return timelineAsync.when(
      error: (error, stackTrace) => Center(child: Text("error $error")),
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (timeline) {
        return FutureBuilder(
          future: timeline.getLikePost(),
          builder: (context, asyncSnapshot) {
            final likePosts = asyncSnapshot.data ?? [];

            if (likePosts.isEmpty) {
              return const Center(child: Text("いいねした投稿がありません"));
            }

            return ListView.separated(
              itemCount: likePosts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return PostBox(post: likePosts[index]);
              },
            );
          },
        );
      },
    );
  }
}
