// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/providers/posts_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: CustomAppbar(title: const Text("Home")),
      body: RefreshIndicator(
        onRefresh: () {
          return ref.read(postsProvider.notifier).fetchPosts();
        },
        child: postsAsync.when(
          data: (posts) => ListView.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return PostBox(post: post);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1);
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text("Error: $error")),
        ),
      ),
    );
  }
}
