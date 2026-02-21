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
    ref.onDispose(() {
      _timelineUpdates.close();
    });

    await ref.watch(databaseReadyProvider.future);
    await ref.watch(accountManagerProvider.future);

    final timeline = Timeline();

    // Timelineの裏側でボットが返信を追加した時に、画面を再描画する設定
    timeline.onTimelineUpdated = () {
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
}

final timelineProvider = AsyncNotifierProvider<TimelineNotifier, Timeline>(
  TimelineNotifier.new,
);

/// Stream版: Timelineの最新状態が流れてくる（追加/削除/更新ごと）
final timelineStreamProvider = StreamProvider.autoDispose<Timeline>((ref) {
  final notifier = ref.watch(timelineProvider.notifier);
  return notifier.timelineUpdates;
});