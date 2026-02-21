// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/widgets/mikata_logo.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userAccountProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final nameController = useTextEditingController();

    Future<void> submit() async {
      await ref
          .read(userAccountProvider.notifier)
          .login(accountName: nameController.text);
      if (!context.mounted) return;
      context.go(RoutePath.home.path);
    }

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (user) {
            return Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (user != null) ...[
                    Text(
                      'すでにログインしています',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                          '@${user.accountID}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 200.ms, delay: 60.ms)
                        .slideY(duration: 240.ms, begin: 0.06, end: 0),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.go(RoutePath.account.path),
                        child: const Text('アカウントへ'),
                      ),
                    ),
                  ] else ...[
                    Spacer(),
                    MikataLogo(type: LogoType.lockUpVertical, size: 84)
                        .animate()
                        .fadeIn(duration: 200.ms)
                        .slideY(
                          duration: 240.ms,
                          begin: 0.06,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 24),
                    Text(
                      'アカウントを作成',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '表示名を決めて開始しましょう！',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '表示名',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => submit(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: submit,
                        label: const Text('作成して開始'),
                      ),
                    ),
                    Spacer(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
