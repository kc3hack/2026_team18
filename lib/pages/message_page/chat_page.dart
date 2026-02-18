// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/direct_message.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key, required this.targetAccount});

  final BotAccount? targetAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 相手の名前を表示（nullならUnknown）
    final title = targetAccount?.accountName ?? "Unknown";

    // ダミーメッセージデータ
    final List<DirectMessage> dummyMessages = [
      DirectMessage(
        accountName: title,
        accountID: targetAccount?.accountID ?? "bot",
        accountUUID: "uuid_bot",
        content: "こんにちは、$title です。今日はどんな気分ですか？",
        dateTime: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      DirectMessage(
        accountName: "Me",
        accountID: "my_id",
        accountUUID: "my_uuid",
        content: "少し話を聞いてほしいです。",
        dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    final reversedMessages = dummyMessages.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: reversedMessages.length,
              itemBuilder: (context, index) {
                final message = reversedMessages[index];
                final isMe = message.accountID == "my_id";
                return _MessageBubble(message: message, isMe: isMe);
              },
            ),
          ),
          const _MessageInputArea(),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMe});
  final DirectMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeFormat = DateFormat('H:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(radius: 16, child: Text(message.accountName[0])),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(timeFormat.format(message.dateTime), style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _MessageInputArea extends StatelessWidget {
  const _MessageInputArea();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const TextField(
                decoration: InputDecoration(hintText: "メッセージを入力...", border: InputBorder.none),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(onPressed: () {}, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
