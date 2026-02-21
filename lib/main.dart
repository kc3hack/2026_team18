// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/theme_provider.dart';

void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/font/OFL.txt');
    yield LicenseEntryWithLineBreaks(['TsunagiGothic'], license);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  registerAppLicenses();

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
