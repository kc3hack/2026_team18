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
  @override
  FutureOr<Timeline> build() async {
    await ref.watch(databaseReadyProvider.future);
    await ref.watch(accountManagerProvider.future);

    final timeline = Timeline();

    final geminiApi = ref.watch(geminiApiProvider);
    if (geminiApi != null) {
      timeline.setGeminiAPI(geminiApi);
    }

    await timeline.loadPost();
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
    return timeline;
  }

  Future<void> addPost(Post post) async {
    final timeline = state.value ?? Timeline();
    try {
      await timeline.addPost(post);
      state = AsyncValue.data(timeline);
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
    } catch (e) {
      debugPrint('Failed to remove post: $e');
      rethrow;
    }
  }
}

final timelineProvider = AsyncNotifierProvider<TimelineNotifier, Timeline>(
  TimelineNotifier.new,
);
