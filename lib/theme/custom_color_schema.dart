// Flutter imports:
import 'package:flutter/material.dart';

final class CustomColorSchema {
  const CustomColorSchema(this.value);

  // -1.0 で青基調、1.0 で赤基調
  final double value;

  double get _t => ((value.clamp(-1.0, 1.0)) + 1.0) / 2.0;

  Color get seedColor => Color.lerp(Colors.blue, Colors.red, _t)!;

  ColorScheme toColorScheme({Brightness brightness = Brightness.light}) {
    return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
  }

  static ColorScheme schemeFor(
    double value, {
    Brightness brightness = Brightness.light,
  }) {
    return CustomColorSchema(value).toColorScheme(brightness: brightness);
  }
}
