// Flutter imports:
import 'package:flutter/material.dart';

final class CustomColorSchema {
  const CustomColorSchema(this.value);

  final double value;

  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    return (value > 0.0) ? pinkLightColorScheme : blueLightColorScheme;
  }

  static ColorScheme schemeFor(
    double value, {
    Brightness brightness = Brightness.light,
  }) {
    return CustomColorSchema(value).toColorScheme(brightness: brightness);
  }

  ColorScheme grayColorScheme({Brightness brightness = Brightness.light}) {
    return grayLightColorScheme;
  }
}

final ColorScheme grayLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.grey.shade900,
  onPrimary: Colors.white,
  primaryContainer: Colors.grey.shade200,
  onPrimaryContainer: Colors.grey.shade900,
  secondary: Colors.grey.shade800,
  onSecondary: Colors.white,
  secondaryContainer: Colors.grey.shade100,
  onSecondaryContainer: Colors.grey.shade900,
  tertiary: Colors.grey.shade700,
  onTertiary: Colors.white,
  tertiaryContainer: Colors.grey.shade100,
  onTertiaryContainer: Colors.grey.shade900,
  error: Colors.red.shade700,
  onError: Colors.white,
  errorContainer: Colors.red.shade100,
  onErrorContainer: Colors.red.shade900,
  surface: Colors.grey.shade50,
  onSurface: Colors.grey.shade900,
  surfaceContainerHighest: Colors.grey.shade100,
  onSurfaceVariant: Colors.grey.shade700,
  outline: Colors.grey.shade400,
  outlineVariant: Colors.grey.shade200,
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.grey.shade900,
  onInverseSurface: Colors.grey.shade50,
  inversePrimary: Colors.grey.shade200,
);

final ColorScheme blueLightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1C2E4A),
  onPrimary: Color.fromARGB(255, 221, 224, 228),
  primaryContainer: Color(0xFF1C2E4A),
  onPrimaryContainer: Color.fromARGB(255, 221, 224, 228),
  secondary: Colors.blueGrey.shade700,
  onSecondary: Colors.white,
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
  surface: Color(0xFF849DBB),
  onSurface: Color(0xFF533a33),
  surfaceContainerHighest: Colors.blueGrey.shade100,
  onSurfaceVariant: Colors.blueGrey.shade700,
  outline: Colors.blueGrey.shade200,
  outlineVariant: Colors.blueGrey.shade100,
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
