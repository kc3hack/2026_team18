// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountPlate extends HookConsumerWidget {
  const AccountPlate({super.key, required this.userName, required this.userId});

  final String userName;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(userName, style: textTheme.displaySmall)],
        ),
        const SizedBox(height: 4),
        Text(userId, style: textTheme.bodyLarge),
      ],
    );
  }
}
