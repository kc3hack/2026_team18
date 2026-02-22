// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/post.dart';
import 'package:mikata/models/timeline.dart';
import 'package:mikata/providers/account_manager_provider.dart';
import 'package:mikata/providers/database_provider.dart';
import 'package:mikata/providers/gemini_provider.dart';

class TimelineNotifier extends AsyncNotifier<Timeline> {
  late final StreamController<Timeline> _timelineUpdates =
      StreamController<Timeline>.broadcast(
        onListen: () {
          final timeline = state.value;
          if (timeline != null && !_timelineUpdates.isClosed) {
            _timelineUpdates.add(timeline);
          }
        },
      );

  Stream<Timeline> get timelineUpdates => _timelineUpdates.stream;

  @override
  FutureOr<Timeline> build() async {
    final timeline = Timeline();

    ref.onDispose(() {
      // Timelineはsingletonなので、破棄時にコールバックを外して
      // dispose後に非同期返信が来てもNotifierへ触らないようにする。
      timeline.onTimelineUpdated = null;
      _timelineUpdates.close();
    });

    await ref.watch(databaseReadyProvider.future);
    await ref.watch(accountManagerProvider.future);

    // Timelineの裏側でボットが返信を追加した時に、画面を再描画する設定
    timeline.onTimelineUpdated = () {
      state = AsyncValue.loading();
      state = AsyncValue.data(timeline);
      if (!_timelineUpdates.isClosed) {
        _timelineUpdates.add(timeline);
      }
    };

    final geminiApi = ref.watch(geminiApiProvider);
    if (geminiApi != null) {
      timeline.setGeminiAPI(geminiApi);
    }

    await timeline.loadPost();
    if (!_timelineUpdates.isClosed) {
      _timelineUpdates.add(timeline);
    }
    return timeline;
  }

  Future<void> fetchTimeline() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(refreshTimeline);
  }

  Future<Timeline> refreshTimeline() async {
    final timeline = state.value ?? Timeline();
    await timeline.loadPost();
    state = AsyncValue.data(timeline);
    if (!_timelineUpdates.isClosed) {
      _timelineUpdates.add(timeline);
    }
    return timeline;
  }

  Future<void> addPost(Post post) async {
    state = const AsyncValue.loading();
    final timeline = state.value ?? Timeline();
    try {
      await timeline.addPost(post);
      state = AsyncValue.data(timeline);
      if (!_timelineUpdates.isClosed) {
        _timelineUpdates.add(timeline);
      }
    } catch (e) {
      debugPrint('Failed to add post: $e');
      rethrow;
    }
  }

  Future<void> updatePost(Post post) async {
    state = const AsyncValue.loading();
    final timeline = state.value ?? Timeline();

    try {
      await timeline;
      state = AsyncValue.data(timeline);
      if (!_timelineUpdates.isClosed) {
        _timelineUpdates.add(timeline);
      }
    } catch (e) {
      debugPrint('Failed to update post: $e');
      rethrow;
    }
  }

  Future<void> removePost(Post post) async {
    final timeline = state.value ?? Timeline();
    try {
      await timeline.removePost(post);
      state = AsyncValue.data(timeline);
      if (!_timelineUpdates.isClosed) {
        _timelineUpdates.add(timeline);
      }
    } catch (e) {
      debugPrint('Failed to remove post: $e');
      rethrow;
    }
  }

  Future<void> toggleLike(Post post) async {
    final timeline = state.value ?? Timeline();

    final previousIsLike = post.isLike;
    final previousLikeCount = post.likeCount;

    final nextIsLike = !previousIsLike;
    final nextLikeCount = nextIsLike
        ? previousLikeCount + 1
        : (previousLikeCount > 0 ? previousLikeCount - 1 : 0);

    // Optimistic update
    _setIsLike(post, nextIsLike);
    post.likeCount = nextLikeCount;

    // Also update the instance in the timeline list (if a different instance exists)
    for (final p in timeline.timeline) {
      if (p.postUUID != post.postUUID) continue;
      _setIsLike(p, nextIsLike);
      p.likeCount = nextLikeCount;
      break;
    }

    state = AsyncValue.data(timeline);
    if (!_timelineUpdates.isClosed) {
      _timelineUpdates.add(timeline);
    }

    try {
      await timeline.upsertPost(post);
    } catch (e) {
      // Revert on failure
      _setIsLike(post, previousIsLike);
      post.likeCount = previousLikeCount;
      for (final p in timeline.timeline) {
        if (p.postUUID != post.postUUID) continue;
        _setIsLike(p, previousIsLike);
        p.likeCount = previousLikeCount;
        break;
      }
      state = AsyncValue.data(timeline);
      if (!_timelineUpdates.isClosed) {
        _timelineUpdates.add(timeline);
      }
      debugPrint('Failed to toggle like: $e');
      rethrow;
    }
  }

  void _setIsLike(Post post, bool value) {
    if (post.isLike == value) return;
    post.toggleLike();
  }
}

final timelineProvider = AsyncNotifierProvider<TimelineNotifier, Timeline>(
  TimelineNotifier.new,
);

/// Stream版: Timelineの最新状態が流れてくる（追加/削除/更新ごと）
final timelineStreamProvider = StreamProvider.autoDispose<Timeline>((ref) {
  final notifier = ref.watch(timelineProvider.notifier);
  return notifier.timelineUpdates;
});
