// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/timeline_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/providers/profile_image_provider.dart';

class NewPostPage extends HookConsumerWidget {
  const NewPostPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final userAsync = ref.watch(userAccountProvider);
    final user = userAsync.value;
    
    // 画像の取得
    final profileImagePath = ref.watch(profileImageProvider).value;

    final inputController = useTextEditingController();
    final characterRate = useState(0.0);

    const maxCharLength = 140;

    useEffect(() {
      void listener() {
        final currentLength = inputController.text.length;
        characterRate.value = (currentLength / maxCharLength).clamp(0.0, 1.0);
      }

      inputController.addListener(listener);
      return () => inputController.removeListener(listener);
    }, [inputController]);

    ImageProvider? avatarImage;
    if (profileImagePath != null) {
      avatarImage = FileImage(File(profileImagePath));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          FilledButton(
            onPressed: (user == null || inputController.text.isEmpty)
                ? null
                : () async {
                    final newPost = Post(
                      authorName: user.accountName,
                      authorUUID: user.accountUUID,
                      content: inputController.text,
                    );

                    try {
                      await ref.read(timelineProvider.notifier).addPost(newPost);
                      if (!context.mounted) return;
                      context.pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("投稿に失敗しました: $e")),
                      );
                    }
                  },
            child: const Text('投稿する'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アイコンの反映
            CircleAvatar(
              radius: 20,
              backgroundColor: colorScheme.surfaceContainerHighest,
              backgroundImage: avatarImage,
              child: avatarImage == null ? Text(user?.accountName[0] ?? '?') : null,
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  hintText: "今日頑張ったことを教えて！",
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
          color: colorScheme.surface,
        ),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.image)),
            Spacer(),
            if (user == null) ...[
              Text(
                '投稿するにはログインしてください',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 8),
            ],
            SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(
                value: characterRate.value,
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
