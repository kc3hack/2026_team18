part of '../post_detail_page.dart';

class ReplySheet extends HookConsumerWidget {
  const ReplySheet({super.key, required this.parentPostUUID});

  final String parentPostUUID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userAccountProvider);

    final inputController = useTextEditingController();
    final focusNode = useFocusNode();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: inputController,
              focusNode: focusNode,
              decoration: InputDecoration(hintText: "返信を入力"),
              maxLines: 1,
            ),
          ),

          OutlinedButton(
            onPressed: (user.value == null)
                ? null
                : () {
                    ref.read(timelineProvider.notifier)
                      ..addPost(
                        Post(
                          authorName: user.value!.accountName,
                          authorUUID: user.value!.accountUUID,
                          content: inputController.text,
                          postDate: DateTime.now(),
                          parentPostUUID: parentPostUUID,
                        ),
                      )
                      ..fetchTimeline();
                    inputController.clear();
                    focusNode.unfocus();
                  },
            child: Text("返信"),
          ),
        ],
      ),
    );
  }
}
