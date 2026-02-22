// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MiniIconButton extends HookConsumerWidget {
  const MiniIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.activeIcon = const Icon(Icons.add, color: Colors.pink),
  });

  final Icon icon;
  final bool isActive;
  final Icon activeIcon;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController = useAnimationController();

    return GestureDetector(
          onTap: () {
            onPressed();
            animationController.forward(from: 0);
          },
          child: (isActive) ? activeIcon : icon,
        )
        .animate(controller: animationController)
        .scale(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          begin: Offset(1.4, 1.4),
          end: Offset(1.0, 1.0),
        );
  }
}
