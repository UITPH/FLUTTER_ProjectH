import 'dart:io';
import 'dart:convert';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<BossModel>> loadBossesFromPath(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => BossModel.fromJson(e)).toList();
}

final bossProvider = StateProvider<List<BossModel>>((ref) => []);
