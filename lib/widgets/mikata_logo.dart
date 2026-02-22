// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/theme/custom_color_schema.dart';

class MikataLogo extends HookConsumerWidget {
  const MikataLogo({super.key, this.size = 48, this.type = LogoType.only});

  final double size;
  final LogoType type;

  String _assetNameForScheme(ColorScheme scheme) {
    final primary = scheme.primary;
    if (primary == blueLightColorScheme.primary) {
      return 'assets/icons/iphone_blue.png';
    }
    if (primary == greenLightColorScheme.primary) {
      return 'assets/icons/iphone_green.png';
    }
    return 'assets/icons/iphone_pink.png';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final assetName = _assetNameForScheme(scheme);

    final image = Image.asset(
      assetName,
      width: size,
      height: size,
      semanticLabel: 'Mikata Logo',
    );

    final label = Text(
      "mikata",
      style: TextStyle(
        color: scheme.primary,
        fontSize: size * 0.5,
        fontWeight: FontWeight.bold,
        fontFamily: 'AutourOne-Regular',
      ),
    );

    return switch (type) {
      LogoType.only => image,
      LogoType.lockUpVertical => Column(
        mainAxisSize: MainAxisSize.min,
        children: [image, const SizedBox(height: 4), label],
      ),
      LogoType.lockUpHorizontal => Row(
        mainAxisSize: MainAxisSize.min,
        children: [image, const SizedBox(width: 8), label],
      ),
    };
  }
}

enum LogoType { only, lockUpVertical, lockUpHorizontal }
