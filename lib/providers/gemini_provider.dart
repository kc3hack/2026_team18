// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/models/gemini_api.dart';

/// Provide a Gemini client via override when needed.
///
/// Default is `null` so the app can run without an API key.
final geminiApiProvider = Provider<GeminiApi?>((ref) => null);
