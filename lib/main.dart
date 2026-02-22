// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/theme_provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart'; // 追加

void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    final thunagiGothicLicense = await rootBundle.loadString(
      'assets/font/autour_one/OFL.txt',
    );
    final autourOneRegularLicense = await rootBundle.loadString(
      'assets/font/tsunagi_gothic/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['TsunagiGothic'], thunagiGothicLicense);
    yield LicenseEntryWithLineBreaks([
      'AutourOneRegular',
    ], autourOneRegularLicense);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

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
      debugShowCheckedModeBanner: false,
      title: 'MIKATA',
      themeMode: ThemeMode.light,
      theme: theme,
      routerConfig: goRouter,
    );
  }
}
