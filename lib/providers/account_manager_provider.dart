// Dart imports:
import 'dart:async';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/account_manager.dart';
import 'package:mikata/providers/database_provider.dart';

class AccountManagerNotifier extends AsyncNotifier<AccountManager> {
  @override
  FutureOr<AccountManager> build() async {
    await ref.watch(databaseReadyProvider.future);

    final manager = AccountManager();
    await manager.loadAccounts();
    return manager;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final manager = AccountManager();
      await manager.loadAccounts();
      return manager;
    });
  }

  Future<void> addAccount(Account account) async {
    final manager = state.value ?? AccountManager();
    manager.addAccount(account);
    state = AsyncValue.data(manager);
  }

  Future<void> removeAccount(Account account) async {
    final manager = state.value ?? AccountManager();
    manager.removeAccount(account);
    state = AsyncValue.data(manager);
  }
}

final accountManagerProvider =
    AsyncNotifierProvider<AccountManagerNotifier, AccountManager>(
      AccountManagerNotifier.new,
    );

final botAccountsProvider = Provider<List<BotAccount>>((ref) {
  final managerAsync = ref.watch(accountManagerProvider);
  return managerAsync.maybeWhen(
    data: (manager) => manager.getBotAccounts(),
    orElse: () => const <BotAccount>[],
  );
});
