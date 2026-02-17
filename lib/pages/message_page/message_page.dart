// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/direct_message.dart';

class MessagePage extends HookConsumerWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI確認用のダミーデータ
    final List<DirectMessage> dummyMessages = [
      DirectMessage(
        userName: "Bot Alice",
        userID: "bot_01",
        userUUID: "uuid_bot_01",
        content: "こんにちは！今日は何かいいことありましたか？",
        dateTime: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      DirectMessage(
        userName: "Me",
        userID: "my_id", // 自分のID
        userUUID: "my_uuid",
        content: "うーん、ちょっと仕事でミスしちゃって…",
        dateTime: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      DirectMessage(
        userName: "Bot Alice",
        userID: "bot_01",
        userUUID: "uuid_bot_01",
        content: "それは大変でしたね…。でも、挑戦した結果なら素晴らしいことだと思いますよ！",
        dateTime: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
       DirectMessage(
        userName: "Me",
        userID: "my_id",
        userUUID: "my_uuid",
        content: "ありがとう、そう言ってもらえると助かる。",
        dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];

    // 新しいものが下に来るように反転
    final reversedMessages = dummyMessages.reversed.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Message")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // 下から積み上げ
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: reversedMessages.length,
              itemBuilder: (context, index) {
                final message = reversedMessages[index];
                // 自分のIDと一致するかで左右出し分け
                final isMe = message.userID == "my_id"; 

                return _MessageBubble(message: message, isMe: isMe);
              },
            ),
          ),
          // 入力エリア
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
            CircleAvatar(
              radius: 16,
              child: Text(message.userName[0]),
            ),
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
          Text(
            timeFormat.format(message.dateTime),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MessageInputArea extends HookConsumerWidget {
  const _MessageInputArea();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), // iOSのSafeArea考慮で下を少し空ける
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
                decoration: InputDecoration(
                  hintText: "メッセージを入力...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () {}, 
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}