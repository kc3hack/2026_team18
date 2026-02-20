// Dart imports:
import 'dart:io';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Project imports:
import 'package:mikata/models/database_helper.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

/// Ensures SQLite is ready (including FFI setup on desktop) and the DB is opened.
final databaseReadyProvider = FutureProvider<DatabaseHelper>((ref) async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final helper = ref.read(databaseHelperProvider);
  await helper.database;
  return helper;
});
