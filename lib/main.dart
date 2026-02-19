// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mikata/models/timeline.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/theme_provider.dart';

import 'package:mikata/models/database_helper.dart';
import 'package:mikata/models/account_manager.dart';

Future<void> init() async {
  DatabaseHelper dbHelper = DatabaseHelper();
  await dbHelper.database;

  Timeline timeline = Timeline();
  await timeline.loadPost();

  AccountManager accountManager = AccountManager();
  await accountManager.loadAccounts();
}

void main() async {
  final scope = ProviderScope(child: MitakaApp());
  await init();

  runApp(scope);
}

class MitakaApp extends HookConsumerWidget {
  const MitakaApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    final theme = ref.watch(themeDataProvider);

    return MaterialApp.router(
      title: 'MIKATA',
      themeMode: ThemeMode.light,
      theme: theme,
      routerConfig: goRouter,
    );
  }
}
