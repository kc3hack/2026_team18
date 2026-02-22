// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
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
    final timelineAsync = ref.watch(timelineProvider);

    return timelineAsync.when(
      error: (error, stackTrace) => Center(child: Text("error $error")),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ).animate().fadeIn(duration: 160.ms),
      data: (timeline) {
        return FutureBuilder(
          future: timeline.getLikePost(),
          builder: (context, asyncSnapshot) {
            final likePosts = asyncSnapshot.data ?? [];

            if (likePosts.isEmpty) {
              return const Center(child: Text("いいねした投稿がありません"))
                  .animate()
                  .fadeIn(duration: 200.ms)
                  .slideY(
                    duration: 240.ms,
                    begin: 0.08,
                    end: 0,
                    curve: Curves.easeOutCubic,
                  );
            }

            return ListView.separated(
              itemCount: likePosts.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final post = likePosts[index];
                return PostBox(post: post)
                    .animate(key: ValueKey(post.postUUID))
                    .fadeIn(duration: 220.ms, delay: (60 * index).ms)
                    .slideY(
                      duration: 260.ms,
                      begin: 0.06,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    );
              },
            );
          },
        );
      },
    );
  }
}
