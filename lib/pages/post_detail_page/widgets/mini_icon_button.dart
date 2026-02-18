// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MiniIconButton extends HookConsumerWidget {
  const MiniIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Icon icon;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(onTap: onPressed, child: icon);
  }
}
