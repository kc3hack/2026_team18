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

  Future<void> fetchTimeline() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final timeline = Timeline();
      timeline.loadPost();
      return timeline;
    });
  }

  Future<void> addPost(Post post) async {
    final timeline = state.value;
    if (timeline == null) return;
    timeline.addPost(post);
    state = AsyncValue.data(timeline);
    timeline.savePost();
  }
}

final timelineProvider =
    AsyncNotifierProvider.autoDispose<TimelineNotifier, Timeline>(
      TimelineNotifier.new,
    );
