// Flutter imports:
import 'package:flutter/material.dart';

final class CustomColorSchema {
  const CustomColorSchema(this.value);

  final double value;

  double get _v => value.clamp(-1.0, 1.0);

  Color get seedColor {
    final v = _v;

    // v < 0: 寒色 -> ニュートラル
    if (v < 0) {
      final t = v + 1.0;
      return _lerpStops(const [Colors.cyan, Colors.purple, Colors.grey], t);
    }

    // v >= 0: ニュートラル -> 暖色
    final t = v;
    return _lerpStops(const [
      Colors.grey,
      Colors.yellow,
      Colors.deepOrange,
      Colors.pink,
    ], t);
  }

  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    print("seedColor: ${seedColor.toARGB32().toRadixString(16)}");
    if (seedColor == Color(0xFF9E9E9E)) {
      return grayColorScheme(brightness: brightness);
    }
    return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  }

  static Color _lerpStops(List<Color> colors, double t) {
    assert(colors.length >= 2);
    final clampedT = t.clamp(0.0, 1.0);
    final scaled = clampedT * (colors.length - 1);
    final index = scaled.floor();

    if (index >= colors.length - 1) {
      return colors.last;
    }

    final localT = scaled - index;
    return Color.lerp(colors[index], colors[index + 1], localT)!;
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
