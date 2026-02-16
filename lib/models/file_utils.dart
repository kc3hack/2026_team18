import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class FileIO {
	Future<String> get _loacalPath async {
		final directory = await getApplicationDocumentsDirectory();
		return directory.path;
	}

	Future<File>  _getFile(String fileName) async {
		final path = await _loacalPath;
		return File('$path/$fileName');
	}

	Future<void> saveFileAsString(String fileName, String content) async {
		final file = await _getFile(fileName);
		await file.writeAsString(content);
	}

	Future<void> saveFileAsBytes(String fileName, List<int> content) async {
		final file = await _getFile(fileName);
		await file.writeAsBytes(content);
	}

	Future<String?> loadTextFile(String fileName) async {
		try {
			final file = await _getFile(fileName);
			if (await file.exists()) {
				return await file.readAsString();
			}
			return null;
		} catch (e) {
			debugPrint("$e");
			return null;
		}
	}

	Future<List<int>?> loadBinaryFile(String fileName) async {
		try {
			final file = await _getFile(fileName);
			if (await file.exists()) {
				return await file.readAsBytes();
			}
			return null;
		} catch (e) {
			debugPrint("$e");
			return null;
		}
	}
}