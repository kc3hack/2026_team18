// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/pages/account_page/account_page.dart';
import 'package:mikata/pages/home_page/home_page.dart';
import 'package:mikata/pages/message_page/chat_page.dart';
import 'package:mikata/pages/message_page/message_page.dart';
import 'package:mikata/pages/new_post_page/new_post_page.dart';
import 'package:mikata/pages/post_detail_page/post_detail_page.dart';
import 'package:mikata/pages/root_page/root_page.dart';
import 'package:mikata/pages/sign_up_page/sign_up_page.dart';

// Project imports:
import 'package:mikata/models/account.dart'; // Account型を渡すためにimport
import 'package:mikata/pages/account_page/settings_page.dart'; // 新規作成
import 'package:mikata/providers/user_account_provider.dart'; // 新規作成

final routerProvider = Provider<GoRouter>((ref) {
  final isLogin = ref.watch(isLoggedInProvider);

  final router = GoRouter(
    initialLocation: (isLogin) ? RoutePath.home.path : RoutePath.signUp.path,

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
                builder: (context, state) => const MessagePage(),
                routes: [
                  // メッセージ一覧からの詳細チャット画面
                  GoRoute(
                    path: 'chat', // /message/chat
                    pageBuilder: (context, state) {
                      // 一覧から渡された相手のアカウント情報を受け取る
                      final account = state.extra as BotAccount?;
                      return MaterialPage(
                        child: ChatPage(targetAccount: account),
                      );
                    },
                  ),
                ],
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
        builder: (context, state) => SettingsPage(),
      ),
      GoRoute(
        path: RoutePath.newPost.path,
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
      GoRoute(
        path: RoutePath.postDetail.path,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: PostDetailPage(post: state.extra as Post),
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: RoutePath.signUp.path,
        builder: (context, state) => SignUpPage(),
      ),
    ],
  );

  return router;
});

enum RoutePath {
  home("/"),
  message("/message"),
  chat("chat"),
  account("/account"),
  settings("/settings"),
  newPost("/new-post"),
  signUp("/signup"),
  postDetail("/post-detail");

  final String path;
  const RoutePath(this.path);
}
