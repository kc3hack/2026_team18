part of '../post_detail_page.dart';

class PostInteractionButtons extends HookConsumerWidget {
  const PostInteractionButtons({
    super.key,
    required this.post,
    required this.focusNode,
  });

  final Post post;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuild when timeline updates (like/bookmark/etc)
    ref.watch(timelineProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
            Text("${post.replyCount} コメント"),
            Text("${post.likeCount} いいね"),
            // Text("${post?.isBookmark}"),
          ],
        ),
        Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MiniIconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () {
                focusNode.requestFocus();
              },
            ),
            MiniIconButton(
              icon: Icon(Icons.favorite_border),
              isActive: post.isLike,
              activeIcon: Icon(Icons.favorite_rounded, color: Colors.pink),
              onPressed: () async {
                ref.read(timelineProvider.notifier)
                  ..toggleLike(post)
                  ..fetchTimeline();
              },
            ),
            MiniIconButton(
              icon: Icon(Icons.bookmark_outline_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
