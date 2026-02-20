part of '../post_detail_page.dart';

class PostContent extends HookConsumerWidget {
  const PostContent({super.key, required this.post});

  final Post post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = DateFormat('yyyy年M月d日 HH:mm').format(post.postDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(post.content, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          formattedDate,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
