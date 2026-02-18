// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/router_provider.dart';
// import 'package:mikata/models/account.dart'; // createUserIDを使うならimport

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 修正: 要件「8桁(大小文字込み記号なし)」に準拠したダミーID
    // 本来は UserAccount クラスの createUserID() で生成されたものを保持します
    final userId = "UserX9yz"; 
    
    final userNameController = TextEditingController(text: "MyUser");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: [
          // 設定画面への遷移
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
            // アイコン変更エリア
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
            
            // 名前変更フィールド
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: "表示名",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            
            // ID表示（変更不可・コピー可能などを想定）
            TextField(
              // 修正: 記号なし8桁のIDを表示
              controller: TextEditingController(text: userId),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "ユーザーID",
                hintText: "8桁の英数字",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge), // アイコンもIDっぽいものに変更
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
                // 保存処理
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