part of '../post_detail_page.dart';

class PostInteractionButtons extends HookConsumerWidget {
  const PostInteractionButtons({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(selectedPostProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [
            Text("${post?.replyCount} コメント"),
            Text("${post?.likeCount} いいね"),
            // Text("${post?.isBookmark}"),
          ],
        ),
        Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MiniIconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () {},
            ),
            MiniIconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
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
