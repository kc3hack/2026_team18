import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageNotifier extends AsyncNotifier<String?> {
  static const _key = 'user.profileImagePath';

  @override
  FutureOr<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key); // 保存されているパスを読み込む
  }

  Future<void> updateImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, path);
    state = AsyncValue.data(path); // 状態を更新してUIに反映
  }
}

final profileImageProvider = AsyncNotifierProvider<ProfileImageNotifier, String?>(
  ProfileImageNotifier.new,
);