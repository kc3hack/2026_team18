// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/providers/account_manager_provider.dart'; // 追加
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class MessagePage extends HookConsumerWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 修正: ダミーリストを削除し、Providerから本物のBotリストを取得する
    final dmThreads = ref.watch(botAccountsProvider);

    return Scaffold(
      appBar: CustomAppbar(title: const Text("Messages")),
      body: ListView.separated(
        itemCount: dmThreads.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final bot = dmThreads[index];
          return MessageBox(bot: bot);
        },
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.bot});

  final BotAccount bot;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(bot.accountID),
      leading: CircleAvatar(child: Text(bot.accountName[0])),
      title: Text(bot.accountName),
      // ID表示も修正
      subtitle: Text("@${bot.accountID}・最新のメッセージ..."),
      onTap: () {
        context.push(RoutePath.chat.path, extra: bot);
      },
    );
  }
}
