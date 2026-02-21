// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/pages/account_page/widgets/account_plate.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

part 'widgets/account_settiing_dialog.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userAccountProvider);

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
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: userAsync.when(
        error: (error, stackTrace) => Center(child: Text("Error: $error")),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (user) {
          return DefaultTabController(
            length: 2,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("画像変更機能は未実装です")),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                "https://placehold.jp/150x150.png",
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                shape: BoxShape.circle,
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
                      const SizedBox(height: 32),
                      AccountPlate(
                        userName: user?.accountName ?? "unknown",
                        userId: user?.accountID ?? "unknown",
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SegmentedTabControl(
                          tabTextColor: colorScheme.onSurfaceVariant,
                          selectedTabTextColor: colorScheme.onPrimaryContainer,
                          indicatorPadding: const EdgeInsets.all(4),
                          squeezeIntensity: 2,
                          tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          selectedTextStyle: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          tabs: [
                            SegmentTab(
                              label: 'いいね',
                              color: colorScheme.primaryContainer,
                              backgroundColor: colorScheme.surface,
                              textColor: colorScheme.onSurfaceVariant,
                              selectedTextColor: colorScheme.onPrimaryContainer,
                            ),
                            SegmentTab(
                              label: 'ブックマーク',
                              color: colorScheme.primaryContainer,
                              backgroundColor: colorScheme.surface,
                              textColor: colorScheme.onSurfaceVariant,
                              selectedTextColor: colorScheme.onPrimaryContainer,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      Center(child: Text("いいねした投稿のリスト")),
                      Center(child: Text("ブックマークした投稿のリスト")),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
