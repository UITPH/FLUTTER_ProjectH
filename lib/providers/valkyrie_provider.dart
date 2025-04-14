import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<Map<String, dynamic>>> loadValkyriesFromPath(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => Map<String, dynamic>.from(e)).toList();
}

final valkyrieProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);
