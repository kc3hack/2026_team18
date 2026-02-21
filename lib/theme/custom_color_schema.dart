// Flutter imports:
import 'package:flutter/material.dart';

final class CustomColorSchema {
  const CustomColorSchema(this.value);

  final double value;

  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    return switch (value) {
      < -0.3 => blueLightColorScheme,
      < 0.3 => greenLightColorScheme,
      _ => pinkLightColorScheme,
    };
  }

  static ColorScheme schemeFor(
    double value, {
    Brightness brightness = Brightness.light,
  }) {
    return CustomColorSchema(value).toColorScheme(brightness: brightness);
  }
}

final ColorScheme blueLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1C2E4A),
  onPrimary: Color.fromARGB(255, 221, 224, 228),
  primaryContainer: Color(0xFF1C2E4A),
  onPrimaryContainer: Color.fromARGB(255, 221, 224, 228),
  secondary: const Color.fromARGB(255, 106, 136, 150),
  onSecondary: Color.fromARGB(255, 215, 221, 224),
  secondaryContainer: Colors.blueGrey.shade50,
  onSecondaryContainer: Colors.blueGrey.shade900,
  tertiary: Colors.grey.shade700,
  onTertiary: Colors.white,
  tertiaryContainer: Colors.blueGrey.shade50,
  onTertiaryContainer: Colors.blueGrey.shade900,
  error: Colors.red.shade700,
  onError: Colors.white,
  errorContainer: Colors.red.shade100,
  onErrorContainer: Colors.red.shade900,
  surface: Color.fromARGB(255, 173, 187, 204),
  onSurface: Color.fromARGB(255, 31, 36, 43),
  surfaceContainerHighest: Color(0xFF849DBB),
  onSurfaceVariant: Color(0xFF1A3A63),
  outline: Colors.blueGrey.shade200,
  outlineVariant: Color.fromARGB(255, 98, 117, 139),
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.blueGrey.shade900,
  onInverseSurface: Colors.lightBlue.shade50,
  inversePrimary: Colors.blueGrey.shade100,
);

final ColorScheme pinkLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.brown.shade800,
  onPrimary: Colors.white,
  primaryContainer: Colors.pink.shade100,
  onPrimaryContainer: Colors.brown.shade900,
  secondary: Colors.brown.shade700,
  onSecondary: Colors.white,
  secondaryContainer: Colors.pink.shade50,
  onSecondaryContainer: Colors.brown.shade900,
  tertiary: Colors.grey.shade700,
  onTertiary: Colors.white,
  tertiaryContainer: Colors.pink.shade50,
  onTertiaryContainer: Colors.brown.shade900,
  error: Colors.red.shade700,
  onError: Colors.white,
  errorContainer: Colors.red.shade100,
  onErrorContainer: Colors.red.shade900,
  surface: Colors.pink.shade50,
  onSurface: Colors.brown.shade900,
  surfaceContainerHighest: Colors.pink.shade100,
  onSurfaceVariant: Colors.brown.shade700,
  outline: Colors.brown.shade200,
  outlineVariant: Colors.pink.shade100,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.brown.shade900,
  onInverseSurface: Colors.pink.shade50,
  inversePrimary: Colors.pink.shade100,
);

final ColorScheme greenLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF4E635E),
  onPrimary: Color(0xFFE2E0C8),
  primaryContainer: Color(0xFF94A59C),
  onPrimaryContainer: Color(0xFF000000),
  secondary: Color(0xFF818C78),
  onSecondary: Color(0xFFE2E0C8),
  secondaryContainer: Color(0xFFA6B49E),
  onSecondaryContainer: Color(0xFF000000),
  tertiary: Color(0xFFA6B49E),
  onTertiary: Color(0xFF000000),
  tertiaryContainer: Color(0xFFE2E0C8),
  onTertiaryContainer: Color(0xFF4E635E),
  error: Colors.red.shade700,
  onError: Colors.white,
  errorContainer: Colors.red.shade100,
  onErrorContainer: Colors.red.shade900,
  surface: Color(0xFFA6B49E),
  onSurface: Color.fromARGB(255, 45, 56, 53),
  surfaceContainerHighest: Color(0xFFE2E0C8),
  onSurfaceVariant: Color(0xFF4E635E),
  outline: Color(0xFF94A59C),
  outlineVariant: Color.fromARGB(255, 96, 121, 80),
  scrim: Colors.black,
  inverseSurface: Color(0xFF4E635E),
  onInverseSurface: Color(0xFFE2E0C8),
  inversePrimary: Color(0xFF94A59C),
);
