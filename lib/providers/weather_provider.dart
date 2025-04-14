import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<Map<String, String>>> loadWeathersFromPath(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => Map<String, String>.from(e)).toList();
}

final weatherProvider = StateProvider<List<Map<String, String>>>((ref) => []);
