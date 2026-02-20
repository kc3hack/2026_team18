// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/account_manager.dart';
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/direct_message.dart';
import 'package:mikata/providers/account_manager_provider.dart';
import 'package:mikata/providers/database_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';

class DirectMessagesNotifier
    extends AsyncNotifier<List<DirectMessage>> {
  @override
  FutureOr<List<DirectMessage>> build(String botUuid) async {
    await ref.watch(databaseReadyProvider.future);
    await ref.watch(accountManagerProvider.future);
    return DatabaseHelper().getDirectMessagesByBotUUID(botUuid);
  }

  Future<void> refresh() async {
    final botUuid = arg;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => DatabaseHelper().getDirectMessagesByBotUUID(botUuid),
    );
  }

  Future<void> sendMessage({required String content}) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final user = ref.read(userAccountProvider).value;
    if (user == null) {
      debugPrint('sendMessage skipped: not logged in');
      return;
    }

    final botUuid = arg;
    final dm = DirectMessage(
      botUUID: botUuid,
      accountName: user.accountName,
      accountUUID: user.accountUUID,
      content: trimmed,
    );

    try {
      final manager = await ref.read(accountManagerProvider.future);
      final account = manager.getAccountByAccountUUID(botUuid);
      final bot = account is BotAccount ? account : null;

      if (bot != null) {
        await bot.addDM(dm);
      } else {
        await DatabaseHelper().insertDirectMessage(dm);
      }
    } catch (e) {
      debugPrint('Failed to send DM: $e');
    }

    await refresh();
  }
}

final directMessagesProvider = AsyncNotifierProvider.autoDispose
    .family<DirectMessagesNotifier, List<DirectMessage>, String>(
      DirectMessagesNotifier.new,
    );
