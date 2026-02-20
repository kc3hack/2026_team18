// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MitakaApp()));
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
