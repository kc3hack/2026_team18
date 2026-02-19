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
    return refreshTimeline();
  }

  Future<void> fetchTimeline() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => refreshTimeline());
  }

  Future<Timeline> refreshTimeline() async {
    print(state);
    final timeline = state.value ?? Timeline();
    timeline.loadPost();
    state = AsyncValue.data(timeline);
    return timeline;
  }

  Future<void> addPost(Post post) async {
    final timeline = state.value;
    if (timeline == null) return;
    timeline.addPost(post);
    state = AsyncValue.data(timeline);
  }
}

final timelineProvider =
    AsyncNotifierProvider.autoDispose<TimelineNotifier, Timeline>(
      TimelineNotifier.new,
    );
