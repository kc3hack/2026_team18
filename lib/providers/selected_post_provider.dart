// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';

class SelectedPostNotifier extends Notifier<Post?> {
  @override
  Post? build() => null;

  void select(Post post) {
    state = post;
  }

  void clear() {
    state = null;
  }
}

final selectedPostProvider = NotifierProvider<SelectedPostNotifier, Post?>(
  SelectedPostNotifier.new,
);
