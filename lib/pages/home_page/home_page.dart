// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/pages/home_page/widgets/post_box.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/timeline_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelineAsync = ref.watch(timelineProvider);
    final userAccountAsync = ref.watch(userAccountProvider);
    final user = userAccountAsync.maybeWhen(
      data: (account) => account,
      orElse: () => null,
    );

    useEffect(() {
      if (user == null) {
        Future.microtask(() => useContext().go(RoutePath.signUp.path));
      }
      return null;
    }, []);

    return Scaffold(
      appBar: CustomAppbar(title: const Text("Home")),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(timelineProvider.notifier).fetchTimeline();
        },
        child: timelineAsync.when(
          data: (timeline) {
            final myPostsFuture = timeline.getPostByAccount(user!);

            return FutureBuilder<List<Post>>(
              future: myPostsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ).animate().fadeIn(duration: 160.ms);
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final myPosts = snapshot.data ?? const <Post>[];
                final noParentPosts = myPosts
                    .where((post) => post.parentPostUUID.isEmpty)
                    .toList();

                if (noParentPosts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Center(
                              child: Text(
                                "なにか投稿してみましょう！",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 220.ms)
                            .slideY(
                              duration: 260.ms,
                              begin: 0.12,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            ),
                  );
                }

                return ListView.separated(
                  itemCount: noParentPosts.length,
                  itemBuilder: (context, index) {
                    final post = noParentPosts[index];
                    return PostBox(post: post)
                        .animate(key: ValueKey(post.postUUID))
                        .fadeIn(
                          duration: 220.ms,
                          delay: (60 * index).ms,
                          curve: Curves.easeOut,
                        )
                        .slideY(
                          duration: 260.ms,
                          begin: 0.06,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 1);
                  },
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ).animate().fadeIn(duration: 160.ms),
          error: (error, stack) => Center(child: Text("Error: $error")),
        ),
      ),
    );
  }
}
