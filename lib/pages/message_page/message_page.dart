// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/providers/router_provider.dart';

class MessagePage extends HookConsumerWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 修正: IDを8桁英数(記号なし)に変更
    final List<BotAccount> dmThreads = [
    //   BotAccount(accountName: "Bot Alice", accountID: "BotAlice"), // 8文字
    //   BotAccount(accountName: "Counselor", accountID: "CnslrBob"), // 8文字
    //   BotAccount(accountName: "Tech Mentor", accountID: "TechMntr"), // 8文字
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: ListView.separated(
        itemCount: dmThreads.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bot = dmThreads[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(bot.accountName[0]),
            ),
            title: Text(bot.accountName),
            // ID表示も修正
            subtitle: Text("@${bot.accountID}・最新のメッセージ..."),
            onTap: () {
              context.go(
                '${RoutePath.message.path}/${RoutePath.chat.path}',
                extra: bot,
              );
            },
          );
        },
      ),
    );
  }
}
