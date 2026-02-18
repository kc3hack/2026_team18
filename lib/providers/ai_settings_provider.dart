// Dart imports:
import 'dart:async';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiSettings {
  final double praise;    // 褒め (0.0 - 100.0)
  final double empathy;   // 共感 (0.0 - 100.0)
  final double criticism; // 批判 (0.0 - 100.0)

  const AiSettings({
    this.praise = 50.0,
    this.empathy = 50.0,
    this.criticism = 10.0,
  });

  AiSettings copyWith({double? praise, double? empathy, double? criticism}) {
    return AiSettings(
      praise: praise ?? this.praise,
      empathy: empathy ?? this.empathy,
      criticism: criticism ?? this.criticism,
    );
  }
}

class AiSettingsNotifier extends AsyncNotifier<AiSettings> {
  static const _keyPraise = 'ai_praise';
  static const _keyEmpathy = 'ai_empathy';
  static const _keyCriticism = 'ai_criticism';

  @override
  FutureOr<AiSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AiSettings(
      praise: prefs.getDouble(_keyPraise) ?? 50.0,
      empathy: prefs.getDouble(_keyEmpathy) ?? 50.0,
      criticism: prefs.getDouble(_keyCriticism) ?? 10.0,
    );
  }

  Future<void> updatePraise(double value) async {
    await _save(_keyPraise, value);
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(praise: value));
    }
  }

  Future<void> updateEmpathy(double value) async {
    await _save(_keyEmpathy, value);
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(empathy: value));
    }
  }

  Future<void> updateCriticism(double value) async {
    await _save(_keyCriticism, value);
    if (state.value != null) {
      state = AsyncData(state.value!.copyWith(criticism: value));
    }
  }

  Future<void> _save(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }
}

final aiSettingsProvider = AsyncNotifierProvider<AiSettingsNotifier, AiSettings>(
  AiSettingsNotifier.new,
);