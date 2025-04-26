import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class BossProvider extends ChangeNotifier {
  final List<BossModel> _bosses = [];
  List<BossModel> get bosses => _bosses;

  BossProvider() {
    _loadBosses();
  }

  Future<void> _loadBosses() async {
    _bosses.addAll(await loadBossesListFromJson());
    notifyListeners();
  }

  Future<void> saveBossesListToJson(List<BossModel> bosses) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Honkai Station/json/bosses.json');
    List<Map<String, dynamic>> jsonList =
        bosses.map((e) => e.toJson()).toList();
    final String data = JsonEncoder.withIndent('    ').convert(jsonList);
    await file.writeAsString(data);
    notifyListeners();
  }
}

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

final bossProvider = ChangeNotifierProvider<BossProvider>(
  (ref) => BossProvider(),
);
