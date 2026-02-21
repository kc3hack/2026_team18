// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/direct_message.dart';
import 'package:mikata/widgets/custom_appbar.dart';

import 'package:flutter_hooks/flutter_hooks.dart'; // 追加
import 'package:mikata/providers/user_account_provider.dart'; // 自分自身の情報取得用

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key, required this.targetAccount});
  final BotAccount? targetAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = targetAccount?.accountName ?? "Unknown";
    final refreshTrigger = useState(0);

    // データベースからメッセージ履歴を読み込む (refreshTriggerが更新されると再取得)
    final dmsFuture = useMemoized(
      () => targetAccount != null
          ? targetAccount!.loadDMs().then((_) => targetAccount!.getDMs())
          : Future.value(<DirectMessage>[]), // nullの場合は空のリストを返す
      [targetAccount, refreshTrigger.value],
    );
    final dmsSnapshot = useFuture(dmsFuture);

    return Scaffold(
      appBar: CustomAppbar(title: Text(title)),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (dmsSnapshot.connectionState == ConnectionState.waiting && refreshTrigger.value == 0) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final messages = targetAccount?.getDMs() ?? [];
                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final message = reversedMessages[index];
                    final isMe = message.accountUUID != message.botUUID;
                    // ※既存の_MessageBubbleをそのまま使用します
                    return _MessageBubble(message: message, isMe: isMe)                    .animate(
                      key: ValueKey(
                        '${message.accountUUID}_${message.dateTime.millisecondsSinceEpoch}',
                      ),
                    )
                    .fadeIn(duration: 180.ms, delay: (50 * index).ms)
                    .slideX(
                      duration: 220.ms,
                      begin: isMe ? 0.08 : -0.08,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    );
                  },
                );
              }
            ),
          ),
          _MessageInputArea(
            targetBot: targetAccount,
            onSent: () => refreshTrigger.value++,
          ).animate()
              .fadeIn(duration: 200.ms)
              .slideY(
                duration: 240.ms,
                begin: 0.2,
                end: 0,
                curve: Curves.easeOutCubic,
              ),
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
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
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
                color: isMe
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest,
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
                      color: isMe
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
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
  const _MessageInputArea({required this.targetBot, required this.onSent});
  
  final BotAccount? targetBot;
  final VoidCallback onSent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final inputController = useTextEditingController();
    final user = ref.watch(userAccountProvider).value;

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
              child: TextField(
                controller: inputController,
                decoration: const InputDecoration(
                  hintText: "メッセージを入力...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () {
              final text = inputController.text.trim();
              if (text.isEmpty || user == null || targetBot == null) return;
              
              final dm = DirectMessage(
                botUUID: targetBot!.accountUUID,
                accountName: user.accountName,
                accountUUID: user.accountUUID,
                content: text,
              );
              
              inputController.clear(); // すぐに入力欄を空にする
              
              // 【修正ポイント】awaitを外し、Geminiの処理を裏側で走らせる
              targetBot!.addDM(dm).then((_) {
                // Geminiから返信が来たらもう一度画面を更新
                if (context.mounted) onSent();
              });
              
              // 自分のメッセージを即座に画面に表示する
              onSent();
            }, 
            icon: const Icon(Icons.send)
          ),
        ],
      ),
    );
  }
}
