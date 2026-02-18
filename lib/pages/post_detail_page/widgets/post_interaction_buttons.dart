part of '../post_detail_page.dart';

class PostInteractionButtons extends HookConsumerWidget {
  const PostInteractionButtons({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 8,
          children: [Text("いいね 123"), Text("コメント 45"), Text("シェア 67")],
        ),
        Divider(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.thumb_up_alt_outlined),
            //   iconSize: 24,
            // ),
            InkWell(child: Icon(Icons.thumb_up_alt_outlined)),
          ],
        ),
        Divider(height: 24),
      ],
    );
  }
}
