// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart'; // 追加
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/direct_message.dart';
import 'package:mikata/providers/user_account_provider.dart'; // 自分自身の情報取得用
import 'package:mikata/widgets/custom_appbar.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key, required this.targetAccount});

  final BotAccount? targetAccount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = targetAccount?.accountName ?? "Unknown";

    // 修正: FutureBuilderなどを使って実際のDM履歴をDBから読み込む
    return Scaffold(
      appBar: CustomAppbar(title: Text(title)),
      body: FutureBuilder<void>(
        future: targetAccount?.loadDMs(), // DBからメッセージをロード
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final messages = targetAccount?.getDMs() ?? [];
          final reversedMessages = messages.reversed.toList(); // 最新を下にするため反転

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final message = reversedMessages[index];
                    // botUUIDとaccountUUIDが違えば自分（ユーザー）の送信メッセージ
                    final isMe = message.accountUUID != message.botUUID; 
                    return _MessageBubble(message: message, isMe: isMe);
                  },
                ),
              ),
              _MessageInputArea(targetBot: targetAccount), // 入力エリアにBot情報を渡す
            ],
          );
        },
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
  const _MessageInputArea({required this.targetBot});
  
  final BotAccount? targetBot;

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
            onPressed: () async {
              if (inputController.text.isEmpty || user == null || targetBot == null) return;
              
              // ▼ 実際の送信処理（DB保存とGemini APIへのリクエスト）▼
              final dm = DirectMessage(
                botUUID: targetBot!.accountUUID,
                accountName: user.accountName,
                accountUUID: user.accountUUID,
                content: inputController.text,
              );
              
              // 送信後に入力欄をクリア
              inputController.clear();
              
              // Gemini APIを叩いて返信を生成（DBにも保存される）
              await targetBot!.addDM(dm);
              
              // ※注意: 本来はここで画面の再描画(setStateやRiverpod更新)が必要
              // 簡易的に画面全体をリビルドするか、StateProviderで監視する
            }, 
            icon: const Icon(Icons.send)
          ),
        ],
      ),
    );
  }
}