part of '../post_detail_page.dart';

class ReplySheet extends HookConsumerWidget {
  const ReplySheet({
    super.key,
    required this.parentPostUUID,
    required this.focusNode,
  });

  final String parentPostUUID;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userAccountProvider);

    final inputController = useTextEditingController();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        color: colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: inputController,
              focusNode: focusNode,
              maxLength: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "返信を入力",
                border: InputBorder.none,
              ),
              maxLines: 1,
            ),
          ),

          FilledButton(
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
