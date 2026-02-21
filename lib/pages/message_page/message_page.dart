// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class MessagePage extends HookConsumerWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BotAccount> dmThreads = [
      BotAccount(
        accountName: "Bot Alice",
        accountID: "ALICE001",
        personality: Personality.empathy,
        prompt: 'やさしく共感しつつ、短く返事してね。',
      ),
      BotAccount(
        accountName: "Bot Bob",
        accountID: "BOB00002",
        personality: Personality.praise,
        prompt: '相手の良い点を見つけて褒める感じで返事してね。',
      ),
      BotAccount(
        accountName: "Bot Carol",
        accountID: "CAROL003",
        personality: Personality.criticism,
        prompt: '改善点を具体的に指摘しつつ、最後は前向きに締めてね。',
      ),
      BotAccount(
        accountName: "Bot Dave",
        accountID: "DAVE0004",
        personality: Personality.empathy,
        prompt: '相手の気持ちを言い換えて安心させる返事をしてね。',
      ),
      BotAccount(
        accountName: "Bot Eve",
        accountID: "EVE00005",
        personality: Personality.praise,
        prompt: 'テンション高めでポジティブに背中を押してね。',
      ),
    ];

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
