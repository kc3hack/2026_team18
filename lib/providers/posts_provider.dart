// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/providers/timeline_provider.dart';

/// Model-driven posts list (backed by `Timeline`).
final postsProvider = Provider<List<Post>>((ref) {
  final timelineAsync = ref.watch(timelineProvider);
  return timelineAsync.maybeWhen(
    data: (timeline) => List<Post>.unmodifiable(timeline.timeline),
    orElse: () => const <Post>[],
  );
});
