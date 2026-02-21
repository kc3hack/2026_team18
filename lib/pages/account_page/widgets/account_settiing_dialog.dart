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
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: "ユーザーID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        FilledButton(
          onPressed: userAsync.isLoading
              ? null
              : () async {
                  final nextName = userNameController.text.trim();
                  final nextId = userIdController.text.trim();

                  if (nextName == user?.accountName &&
                      nextId == user?.accountID) {
                    Navigator.of(context).pop();
                    return;
                  }

                  if (nextName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ユーザー名を入力してください')),
                    );
                    return;
                  }

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
