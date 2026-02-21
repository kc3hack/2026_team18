// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:mikata/models/account.dart';
import 'package:mikata/models/database_helper.dart';
import 'package:mikata/providers/account_manager_provider.dart';
import 'package:mikata/providers/database_provider.dart';

class UserAccountProvider extends AsyncNotifier<UserAccount?> {
  static const _keyAccountName = 'user.accountName';
  static const _keyAccountId = 'user.accountId';
  static const _keyAccountUuid = 'user.accountUuid';

  static final RegExp _accountIdPattern = RegExp(r'^[0-9A-Za-z]{8}$');

  @override
  Future<UserAccount?> build() async {
    await ref.watch(databaseReadyProvider.future);
    // Ensure accounts are loaded so `Post.fromMap` etc can resolve names.
    // (User account may still be synced below.)
    await ref.watch(accountManagerProvider.future);

    final prefs = await SharedPreferences.getInstance();
    final accountName = prefs.getString(_keyAccountName);
    if (accountName == null || accountName.trim().isEmpty) {
      return null;
    }

    final user = UserAccount(
      accountName: accountName.trim(),
      accountID: prefs.getString(_keyAccountId),
      accountUUID: prefs.getString(_keyAccountUuid),
    );

    await _save(user);
    await _syncToAccountManager(user);

    return user;
  }

  Future<void> login({required String accountName}) async {
    final trimmed = accountName.trim();
    if (trimmed.isEmpty) return;

    final user = UserAccount(accountName: trimmed);
    state = AsyncValue.data(user);
    await _save(user);
    await _syncToAccountManager(user);
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

    currentUser.changeAccountName(trimmed);
    state = AsyncValue.data(currentUser);
    await _save(currentUser);
    await _syncToAccountManager(currentUser);
  }

  Future<void> updateProfile({String? accountName, String? accountId}) async {
    state = const AsyncValue.loading();
    final trimmedName = accountName?.trim();
    final trimmedId = accountId?.trim();

    final currentUser = state.value;
    if (currentUser == null) {
      if (trimmedName != null && trimmedName.isNotEmpty) {
        await login(accountName: trimmedName);
      }
      return;
    }

    var didChange = false;

    if (trimmedName != null &&
        trimmedName.isNotEmpty &&
        trimmedName != currentUser.accountName) {
      currentUser.changeAccountName(trimmedName);
      didChange = true;
    }

    if (trimmedId != null &&
        trimmedId.isNotEmpty &&
        _accountIdPattern.hasMatch(trimmedId) &&
        trimmedId != currentUser.accountID) {
      currentUser.changeAccountID(trimmedId);
      didChange = true;
    }

    if (!didChange) return;

    state = AsyncValue.data(currentUser);
    await _save(currentUser);
    await _syncToAccountManager(currentUser);
  }

  Future<void> _save(UserAccount user) async {
    try {
      await ref.read(databaseReadyProvider.future);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyAccountName, user.accountName);
      await prefs.setString(_keyAccountId, user.accountID);
      await prefs.setString(_keyAccountUuid, user.accountUUID);

      // Keep SQLite accounts table in sync with the latest user info.
      await DatabaseHelper().insertAccount(user);
    } catch (e) {
      debugPrint('Failed to persist user account: $e');
    }
  }

  Future<void> _syncToAccountManager(UserAccount user) async {
    try {
      final manager = await ref.read(accountManagerProvider.future);
      final existing = manager.getAccountByAccountUUID(user.accountUUID);
      if (existing == null) {
        // `addAccount` also syncs to DB; safe with ConflictAlgorithm.replace.
        manager.addAccount(user);
        return;
      }

      if (existing is Account) {
        if (existing.accountName != user.accountName) {
          existing.changeAccountName(user.accountName);
        }
        if (existing.accountID != user.accountID) {
          existing.accountID = user.accountID;
        }
      }
    } catch (e) {
      debugPrint('Failed to sync user into AccountManager: $e');
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
