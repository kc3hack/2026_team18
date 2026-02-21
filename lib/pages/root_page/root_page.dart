// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
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
      body: Animate(
        key: ValueKey(navigationShell.currentIndex),
        effects: [
          FadeEffect(duration: 200.ms, curve: Curves.easeOut),
          SlideEffect(
            duration: 220.ms,
            begin: Offset(0, 0.03),
            end: Offset.zero,
            curve: Curves.easeOutCubic,
          ),
        ],
        child: navigationShell,
      ),
      floatingActionButton: (navigationShell.currentIndex == 0)
          ? FloatingActionButton(
                  shape: StadiumBorder(),
                  elevation: 0,
                  onPressed: () => context.push(RoutePath.newPost.path),
                  child: const Icon(Icons.add_rounded),
                )
                .animate()
                .fadeIn(duration: 180.ms)
                .scale(
                  duration: 220.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1, 1),
                )
          : null,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_rounded),
                label: "Home",
              ),
              NavigationDestination(
                icon: const Icon(Icons.email_rounded),
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
