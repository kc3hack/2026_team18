// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      floatingActionButton: (navigationShell.currentIndex == 0)
          ? FloatingActionButton(
              onPressed: () => context.push(RoutePath.newPost.path),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: "Home",
              ),
              NavigationDestination(
                icon: const Icon(Icons.message_rounded),
                label: "Message",
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_circle_rounded),
                label: "Account",
              ),
            ],
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) => navigationShell.goBranch(index),
          ),
        ),
      ),
    );
  }
}
