part of '../account_page.dart';

class AccountSettiingDialog extends HookConsumerWidget {
  const AccountSettiingDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userAccountProvider);

    final userNameController = useTextEditingController();
    final userIdController = useTextEditingController();

    final user = userAsync.maybeWhen(data: (u) => u, orElse: () => null);

    useEffect(() {
      userNameController.text = user?.accountName ?? '';
      userIdController.text = user?.accountID ?? '';
      return null;
    }, [user?.accountUUID]);

    return AlertDialog(
      title: const Text("アカウント編集"),
      content: userAsync.when(
        error: (error, stackTrace) => Text("Error: $error"),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (user) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: "ユーザー名",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 16),
              // 修正: IDを変更不可(readOnly)に
              TextField(
                controller: userIdController,
                readOnly: true, 
                decoration: InputDecoration(
                  labelText: "ユーザーID (変更不可)",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.badge_rounded),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        FilledButton(
          onPressed: (user == null)
              ? null
              : () async {
                  final nextName = userNameController.text.trim();
                  final nextId = userIdController.text.trim();

                  // 修正: 変更がない場合でも pop() を呼んでダイアログを閉じる
                  if (nextName == user.accountName && nextId == user.accountID) {
                    Navigator.of(context).pop();
                    return;
                  }

                  if (nextName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ユーザー名を入力してください')),
                    );
                    return;
                  }

                  // ※IDは変更不可にしたため、基本的にはここのチェックは通り抜ける
                  if (!RegExp(r'^[0-9A-Za-z]{8}$').hasMatch(nextId)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ユーザーIDは8桁の英数字にしてください')),
                    );
                    return;
                  }

                  await ref
                      .read(userAccountProvider.notifier)
                      .updateProfile(accountName: nextName, accountId: nextId);

                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
          child: const Text("保存"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("閉じる"),
        ),
      ],
    );
  }

  static void show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const AccountSettiingDialog(),
    );
  }
}