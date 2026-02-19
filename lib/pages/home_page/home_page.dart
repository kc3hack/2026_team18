// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/providers/timeline_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineProvider);

    return Scaffold(
      appBar: CustomAppbar(title: const Text("Home")),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(timelineProvider.notifier).fetchTimeline();
        },
        child: timelineAsync.when(
          data: (timeline) {
            final noParentPosts = timeline.timeline
                .where((post) => post.parentPostUUID.isEmpty)
                .toList();

            return ListView.separated(
              itemCount: noParentPosts.length,
              itemBuilder: (context, index) {
                final post = noParentPosts[index];
                return PostBox(post: post);
              },
              separatorBuilder: (context, index) {
                return const Divider(height: 1);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text("Error: $error")),
        ),
      ),
    );
  }
}
