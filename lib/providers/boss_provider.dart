import 'dart:io';
import 'dart:convert';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

Future<List<BossModel>> loadBossesListFromJson() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/bosses.json');
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => BossModel.fromJson(e)).toList();
}

final bossProvider = StateProvider<List<BossModel>>((ref) => []);
