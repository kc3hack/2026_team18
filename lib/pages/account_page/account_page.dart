// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:mikata/pages/account_page/widgets/account_plate.dart';
import 'package:mikata/pages/account_page/widgets/bookmark_tab.dart';
import 'package:mikata/pages/account_page/widgets/favorite_tab.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/providers/profile_image_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

part 'widgets/account_settiing_dialog.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userAccountProvider);
    final profileImagePath = ref.watch(profileImageProvider).value; 
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbar(
        title: const Text("Account"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => AccountSettiingDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push(RoutePath.settings.path),
          ),
        ],
      ),
      body: userAsync.when(
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (user) {
          if (user == null) {
            return const Center(child: Text("ログインしていません"));
          }

          return SafeArea(
            child: DefaultTabController(
              length: 2,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              ref
                                  .read(profileImageProvider.notifier)
                                  .updateImagePath(pickedFile.path);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: colorScheme.surfaceContainerHighest,
                                backgroundImage: profileImagePath != null
                                    ? FileImage(File(profileImagePath)) as ImageProvider
                                    : const NetworkImage("https://placehold.jp/150x150.png"),
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AccountPlate(
                          userName: user.accountName,
                          userId: '@${user.accountID}',
                        ),
                        const SizedBox(height: 24),
                        
                        // ▼ 外部パッケージをやめて、Flutter標準のTabBarで実装 ▼
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: TabBar(
                              dividerColor: Colors.transparent, // デフォルトの下線を消す
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              labelColor: colorScheme.onPrimaryContainer,
                              unselectedLabelColor: colorScheme.onSurfaceVariant,
                              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                              splashBorderRadius: BorderRadius.circular(22),
                              tabs: const [
                                Tab(text: 'いいね'),
                                Tab(text: 'ブックマーク'),
                              ],
                            ),
                          ),
                        ),
                        // ▲ 標準TabBarここまで ▲
                        
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  SliverFillRemaining(
                    child: TabBarView(
                      children: [
                        FavoriteTab(user: user),
                        BookmarkTab(user: user),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}