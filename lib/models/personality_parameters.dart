// Dart imports:
import 'dart:async'; // ← 追加

// Package imports:
import 'package:shared_preferences/shared_preferences.dart'; // ← 追加

// Project imports:
import 'package:mikata/models/account_manager.dart';

class PersonalityParameters {
//private member
    static final PersonalityParameters _instance = PersonalityParameters._internal();

    int _praise    = 0;
    int _empathy   = 0;
    int _criticism = 0;

    // private method
    PersonalityParameters._internal();

// public method
    factory PersonalityParameters() => _instance;

    int get praise => _praise;
    set praise(int value) {
        _praise = value.clamp(0, 100);
    }

    int get empathy => _empathy;
    set empathy(int value) {
        _empathy = value.clamp(0, 100);
    }

    int get criticism => _criticism;
    set criticism(int value) {
        _criticism = value.clamp(0, 100);
    }

    // 非同期メソッド (Future) に変更
    Future<List<int>> getPersonalityCount() async {
        await _fetchParameters();
        
        final List<int> result = [0, 0, 0];
        final sum = praise + empathy + criticism;

        if (sum == 0) {
            result[0] = (maxReplies / 3).toInt();
            result[1] = (maxReplies / 3).toInt();
            result[2] = (maxReplies / 3).toInt();
            return result;
        }

        double p = (praise / sum) * maxReplies;
        double e = (empathy / sum) * maxReplies;
        double c = (criticism / sum) * maxReplies;

        result[0] = p.toInt();
        result[1] = e.toInt();
        result[2] = c.toInt();

        // 端数調整（余った枠を一番比率が高いものに足す）
        int currentSum = result[0] + result[1] + result[2];
        if (currentSum < maxReplies) {
            int remainder = maxReplies - currentSum;
            if (p >= e && p >= c) {
                result[0] += remainder;
            } else if (e >= p && e >= c) {
                result[1] += remainder;
            } else {
                result[2] += remainder;
            }
        }

        return result;
    }

    // ▼ 追加: SharedPreferences から設定値を読み込む処理 ▼
    Future<void> _fetchParameters() async {
        final prefs = await SharedPreferences.getInstance();
        
        // AiSettingsNotifier で保存しているキー名と一致させます
        // デフォルト値は praise:50, empathy:50, criticism:10
        praise = (prefs.getDouble('ai_praise') ?? 50.0).toInt();
        empathy = (prefs.getDouble('ai_empathy') ?? 50.0).toInt();
        criticism = (prefs.getDouble('ai_criticism') ?? 10.0).toInt();
    }
}
