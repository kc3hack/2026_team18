// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/ai_settings_provider.dart';
import 'package:mikata/theme/custom_color_schema.dart';

class ThemeNotifier extends Notifier<ThemeData> {
  @override
  ThemeData build() {
    // カラースキーマの元になる値（-1.0〜1.0）
    final value = -1.0;
    final scheme = CustomColorSchema(
      value,
    ).toColorScheme(brightness: Brightness.light);
    return ThemeData(useMaterial3: true, colorScheme: scheme);
  }

  void updateColorSchemaValue(double newValue) {
    state = state.copyWith(
      colorScheme: CustomColorSchema(
        newValue,
      ).toColorScheme(brightness: Brightness.light),
    );
  }
}

// final themeDataProvider = NotifierProvider<ThemeNotifier, ThemeData>(
//   ThemeNotifier.new,
// );

final themeDataProvider = Provider((ref) {
  final aiSettings = ref.watch(aiSettingsProvider);

  final textTheme = ThemeData(useMaterial3: true).textTheme;
  final hotFont = GoogleFonts.mPlus1pTextTheme(textTheme);
  final coldFont = GoogleFonts.zenKakuGothicNewTextTheme(textTheme);

  return aiSettings.when(
    data: (settings) {
      final praiseValue =
          (settings.praise - 50.0) / 50.0; // 例: 褒めの値を-1.0〜1.0に変換
      final empathyValue = (settings.empathy - 50.0) / 50.0; // 共感の値を-1.0〜1.0に変換
      final criticismValue =
          (settings.criticism - 10.0) / 90.0; // 批判の値を-1.0〜1.0に変換

      final value = praiseValue + empathyValue - criticismValue / 2.0;

      final font = value > 0 ? hotFont : coldFont;

      final scheme = CustomColorSchema(
        value,
      ).toColorScheme(brightness: Brightness.light);
      return ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        textTheme: font,
      );
    },
    loading: () => ThemeData(
      useMaterial3: true,
      colorScheme: CustomColorSchema(
        0,
      ).toColorScheme(brightness: Brightness.light),
    ),
    error: (err, stack) => ThemeData(
      useMaterial3: true,
      colorScheme: CustomColorSchema(
        0,
      ).toColorScheme(brightness: Brightness.light),
    ),
  );
});
