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
import 'package:mikata/models/database_helper.dart';

final activeDmBotsProvider = FutureProvider.autoDispose<List<BotAccount>>((ref) async {
  final manager = await ref.watch(accountManagerProvider.future);
  final db = await DatabaseHelper().database;
  
  // DM履歴があるBotのUUIDだけを取得
  final maps = await db.rawQuery('SELECT DISTINCT bot_uuid FROM direct_messages');
  final activeBotUuids = maps.map((m) => m['bot_uuid'] as String).toSet();
  
  return manager.getBotAccounts().where((bot) => activeBotUuids.contains(bot.accountUUID)).toList();
});

class MessagePage extends HookConsumerWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBotsAsync = ref.watch(activeDmBotsProvider);

    return Scaffold(
      appBar: CustomAppbar(title: const Text("Messages")),
      body: activeBotsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (dmThreads) {
          if (dmThreads.isEmpty) {
            return const Center(
              child: Text("まだメッセージのやり取りはありません\n投稿画面からDMを送ってみましょう！", textAlign: TextAlign.center)
            );
          }
          return ListView.separated(
            itemCount: dmThreads.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final bot = dmThreads[index];
              return ListTile(
                leading: CircleAvatar(child: Text(bot.accountName[0])),
                title: Text(bot.accountName),
                subtitle: Text("@${bot.accountID}"),
                onTap: () {
                  context.push(RoutePath.chat.path, extra: bot);
                },
              );
            },
          );
        }
      ),
    );
  }
}

// class MessageBox extends StatelessWidget {
//   const MessageBox({super.key, required this.bot});

//   final BotAccount bot;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       key: ValueKey(bot.accountID),
//       leading: CircleAvatar(child: Text(bot.accountName[0])),
//       title: Text(bot.accountName),
//       // ID表示も修正
//       subtitle: Text("@${bot.accountID}・最新のメッセージ..."),
//       onTap: () {
//         context.push(RoutePath.chat.path, extra: bot);
//       },
//     );
//   }
// }
