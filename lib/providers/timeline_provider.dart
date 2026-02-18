// Dart imports:
import 'dart:async';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/models/timeline.dart';

class TimelineNotifier extends AsyncNotifier<Timeline> {
  @override
  FutureOr<Timeline> build() async {
    final timeline = Timeline();
    timeline.loadPost();
    return timeline;
  }

  void fetchTimeline() async {
    state = const AsyncValue.loading();
    final timeline = Timeline();
    timeline.loadPost();
    state = AsyncValue.data(timeline);
  }

  void addPost(Post post) {
    final timeline = state.value;
    if (timeline == null) return;
    timeline.addPost(post);
    // timeline.savePost();
    state = AsyncValue.data(timeline);
  }
}

final timelineProvider =
    AsyncNotifierProvider.autoDispose<TimelineNotifier, Timeline>(
      TimelineNotifier.new,
    );
