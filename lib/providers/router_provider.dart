// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/pages/account_page/account_page.dart';
import 'package:mikata/pages/home_page/home_page.dart';
import 'package:mikata/pages/message_page/message_page.dart';
import 'package:mikata/pages/new_post_page/new_post_page.dart';
import 'package:mikata/pages/root_page/root_page.dart';

final routerProvider = Provider<GoRouter>((ref) => router);

final router = GoRouter(
  initialLocation: RoutePath.home.path,

  routes: [
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootPage(navigationShell: navigationShell),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.home.path,
              builder: (context, state) => HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.message.path,
              builder: (context, state) => MessagePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RoutePath.account.path,
              builder: (context, state) => AccountPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RoutePath.settings.path,
      pageBuilder: (context, state) => NoTransitionPage(child: Container()),
    ),
    GoRoute(
      path: RoutePath.newPostPage.path,
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: NewPostPage(),
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          );
        },
      ),
    ),
  ],
);

enum RoutePath {
  home("/"),
  message("/message"),
  account("/account"),
  settings("/settings"),
  newPostPage("/new-post");

  final String path;
  const RoutePath(this.path);
}
