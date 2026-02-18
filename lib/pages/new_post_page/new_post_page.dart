// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/timeline_provider.dart';

class NewPostPage extends HookConsumerWidget {
  const NewPostPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

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

    return Scaffold(
      appBar: AppBar(
        actions: [
          FilledButton(
            onPressed: () async {
              final newPost = Post(
                authorName: "ユーザー名",
                authorUuid: "ユーザーUUID",
                content: inputController.text,
                postDate: DateTime.now(),
              );
              await ref.read(timelineProvider.notifier).addPost(newPost);
              context.pop();
            },
            child: Text("投稿する"),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://placehold.jp/150x150.png"),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  hintText: "いまどうしてる？",
                  border: InputBorder.none,
                ),
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
            SizedBox.square(
              dimension: 28,
              child: CircularProgressIndicator(
                value: characterRate.value,
                strokeCap: StrokeCap.round,
                // strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
