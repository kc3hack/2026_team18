part of '../post_detail_page.dart';

class PostAccountHeader extends HookConsumerWidget {
  const PostAccountHeader({super.key, required this.post});

  final Post post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // アカウント情報と画像の取得
    final accountManager = ref.watch(accountManagerProvider).value;
    final authorAccount = accountManager?.getAccountByAccountUUID(
      post.authorUUID,
    );
    final isMe =
        authorAccount?.accountUUID ==
        ref.watch(userAccountProvider).value?.accountUUID;
    final profileImagePath = ref.watch(profileImageProvider).value;

    ImageProvider? avatarImage;
    if (isMe && profileImagePath != null) {
      avatarImage = FileImage(File(profileImagePath));
    }

    return Row(
      children: [
        // アイコンの反映
        CircleAvatar(
          radius: 20,
          backgroundColor: colorScheme.surfaceContainerHighest,
          backgroundImage: avatarImage,
          child: avatarImage == null ? Text(post.authorName[0]) : null,
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
            // UserIDの反映
            Text(
              "@${authorAccount?.accountID ?? 'unknown'}",
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              softWrap: true,
            ),
          ],
        ),
        Spacer(),
        (!isMe)
            ? FilledButton.icon(
                onPressed: () {},
                icon: Icon(Icons.email_rounded),
                label: Text("DM"),
              )
            : IconButton(
                onPressed: () =>
                    RemovePostDialog.show(context, post, RoutePath.postDetail),
                icon: Icon(Icons.more_vert_rounded),
              ),
      ],
    );
  }
}
