// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/theme/custom_color_schema.dart';

class ThemeNotifier extends Notifier<ThemeData> {
  @override
  ThemeData build() {
    // カラースキーマの元になる値（-1.0〜1.0）
    final value = 1.0;
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

final themeDataProvider = NotifierProvider<ThemeNotifier, ThemeData>(
  ThemeNotifier.new,
);
