part of '../post_detail_page.dart';

class PostAccountHeader extends HookConsumerWidget {
  const PostAccountHeader({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(selectedPostProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (post == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage("https://placehold.jp/150x150.png"),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.authorName,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              softWrap: true,
            ),
            Text(
              "@userID",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              softWrap: true,
            ),
          ],
        ),
        Spacer(),
        FilledButton.icon(
          onPressed: () {},
          icon: Icon(Icons.email_rounded),
          label: Text("DM"),
        ),
      ],
    );
  }
}
