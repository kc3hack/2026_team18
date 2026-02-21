// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/pages/account_page/widgets/account_plate.dart';
import 'package:mikata/providers/router_provider.dart';
import 'package:mikata/providers/user_account_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

part 'widgets/account_settiing_dialog.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userAccountProvider);

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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // TextField(
                  //   controller: userNameController,
                  //   decoration: const InputDecoration(
                  //     labelText: "表示名",
                  //     border: OutlineInputBorder(),
                  //     prefixIcon: Icon(Icons.person),
                  //   ),
                  // ),
                  AccountPlate(
                    userName: user?.accountName ?? "unknown",
                    userId: user?.accountID ?? "unknown",
                  ),
                  const SizedBox(height: 16),

                  // TextField(
                  //   // IDは固定なのでHooks不要だが、TextEditingControllerを使うならuse〜が推奨
                  //   controller: useTextEditingController(text: userId),
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     labelText: "ユーザーID",
                  //     hintText: "8桁の英数字",
                  //     border: OutlineInputBorder(),
                  //     prefixIcon: Icon(Icons.badge),
                  //     filled: true,
                  //   ),
                  // ),
                  // const SizedBox(height: 32),
                  // FilledButton.icon(
                  //   onPressed: () {
                  //     // userNameController.text で入力値を取得可能
                  //     print("New Name: ${userNameController.text}");
                  //   },
                  //   icon: const Icon(Icons.save),
                  //   label: const Text("プロフィールを保存"),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
