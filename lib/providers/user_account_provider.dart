// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:mikata/models/account.dart';

class UserAccountProvider extends AsyncNotifier<UserAccount?> {
  static const _keyAccountName = 'user.accountName';
  static const _keyAccountId = 'user.accountId';
  static const _keyAccountUuid = 'user.accountUuid';

  @override
  Future<UserAccount?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final accountName = prefs.getString(_keyAccountName);
    if (accountName == null || accountName.trim().isEmpty) {
      return null;
    }

    return UserAccount(
      accountName: accountName,
      accountID: prefs.getString(_keyAccountId),
      accountUUID: prefs.getString(_keyAccountUuid),
    );
  }

  Future<void> login({required String accountName}) async {
    final trimmed = accountName.trim();
    if (trimmed.isEmpty) return;

    final user = UserAccount(accountName: trimmed);
    state = AsyncValue.data(user);
    await _save(user);
  }

  Future<void> logout() async {
    state = const AsyncValue.data(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccountName);
    await prefs.remove(_keyAccountId);
    await prefs.remove(_keyAccountUuid);
  }

  Future<void> updateAccountName(String accountName) async {
    final trimmed = accountName.trim();
    if (trimmed.isEmpty) return;

    final currentUser = state.value;
    if (currentUser == null) {
      await login(accountName: trimmed);
      return;
    }

    final updated = UserAccount(
      accountName: trimmed,
      accountID: currentUser.accountID,
      accountUUID: currentUser.accountUUID,
    );
    state = AsyncValue.data(updated);
    await _save(updated);
  }

  Future<void> _save(UserAccount user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAccountName, user.accountName);
      await prefs.setString(_keyAccountId, user.accountID);
      await prefs.setString(_keyAccountUuid, user.accountUUID);
    } catch (e) {
      debugPrint('Failed to persist user account: $e');
    }
  }
}

final userAccountProvider =
    AsyncNotifierProvider<UserAccountProvider, UserAccount?>(
      UserAccountProvider.new,
    );

final isLoggedInProvider = Provider<bool>((ref) {
  final userAsync = ref.watch(userAccountProvider);
  return userAsync.maybeWhen(data: (user) => user != null, orElse: () => false);
});
