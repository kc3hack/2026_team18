// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/selected_post_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

part 'widgets/post_account_header.dart';
part 'widgets/post_content.dart';
part 'widgets/post_interaction_buttons.dart';

class PostDetailPage extends HookConsumerWidget {
  const PostDetailPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppbar(title: const Text("投稿の詳細")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              PostAccountHeader(),
              SizedBox(height: 12),
              PostContent(),
              Divider(height: 24),
              PostInteractionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
