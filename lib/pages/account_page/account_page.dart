// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 【Hooks修正】useTextEditingControllerを使用
    // これにより、画面破棄時に自動でdispose（メモリ解放）されます
    final userNameController = useTextEditingController(text: "MyUser");
    final userId = "UserX9yz"; 

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(RoutePath.settings.path),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
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
                    backgroundImage: NetworkImage("https://placehold.jp/150x150.png"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 20, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: "表示名",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              // IDは固定なのでHooks不要だが、TextEditingControllerを使うならuse〜が推奨
              controller: useTextEditingController(text: userId),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "ユーザーID",
                hintText: "8桁の英数字",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                filled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "※IDは自動生成された8桁の英数字です",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                // userNameController.text で入力値を取得可能
                print("New Name: ${userNameController.text}");
              },
              icon: const Icon(Icons.save),
              label: const Text("プロフィールを保存"),
            ),
          ],
        ),
      ),
    );
  }
}