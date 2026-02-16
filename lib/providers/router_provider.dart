// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) => router);

final router = GoRouter(
  initialLocation: RoutePath.home.path,

  routes: [
    GoRoute(
      path: RoutePath.home.path,
      pageBuilder: (context, state) => NoTransitionPage(child: Container()),
    ),
    GoRoute(
      path: RoutePath.settings.path,
      pageBuilder: (context, state) => NoTransitionPage(child: Container()),
    ),
  ],
);

enum RoutePath {
  home("/"),
  settings("/settings");

  final String path;
  const RoutePath(this.path);
}
