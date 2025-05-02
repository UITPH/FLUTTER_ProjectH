import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbyssBossProvider extends ChangeNotifier {
  final List<AbyssBossModel> _bosses = [];
  List<AbyssBossModel> get bosses => _bosses;
  bool _isLoaded = false;

  AbyssBossProvider() {
    _loadBosses();
  }

  Future<void> _loadBosses() async {
    _bosses.addAll(await loadBossesListFromDataBase());
    _isLoaded = true;
    notifyListeners();
  }

  void addBoss(AbyssBossModel newBoss) {
    if (_isLoaded == false) return;
    _bosses.add(newBoss);
    notifyListeners();
  }

  void removeBoss(String id) {
    if (_isLoaded == false) return;
    _bosses.removeWhere((boss) => boss.id == id);
    notifyListeners();
  }

  void restoreBoss(String id) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> data = await db.rawQuery(
      '''
      SELECT
        abyssbosses.id,
        abyssbosses.name,
        abyssbosses.id_weather,
        abyssbosses.mechanic,
        abyssbosses.resistance,
        '[' || GROUP_CONCAT('"' || abyssboss_teamrec.first_valk ||'"') || ']' AS first_valk,
        '[' || GROUP_CONCAT('"' || abyssboss_teamrec.second_valk ||'"') || ']' AS second_valk,
        '[' || GROUP_CONCAT('"' || abyssboss_teamrec.third_valk ||'"') || ']' AS third_valk,
        '[' || GROUP_CONCAT('"' || abyssboss_teamrec.elf ||'"') || ']' AS elf,
        '[' || GROUP_CONCAT('"' || abyssboss_teamrec.note ||'"') || ']' AS note
      FROM abyssbosses
      JOIN abyssboss_teamrec ON abyssbosses.id = abyssboss_teamrec.id_abyssboss
      WHERE abyssbosses.id = ?
      GROUP BY abyssbosses.id
''',
      [id],
    );
    _bosses.add(AbyssBossModel.fromMap(data[0]));
    notifyListeners();
  }
}

Future<List<AbyssBossModel>> loadBossesListFromDataBase() async {
  final db = await DatabaseHelper.getDatabase();
  final List<Map<String, dynamic>> data = await db.rawQuery('''
    SELECT
      abyssbosses.id,
      abyssbosses.name,
      abyssbosses.id_weather,
      abyssbosses.mechanic,
      abyssbosses.resistance,
      '[' || GROUP_CONCAT('"' || abyssboss_teamrec.first_valk ||'"') || ']' AS first_valk,
      '[' || GROUP_CONCAT('"' || abyssboss_teamrec.second_valk ||'"') || ']' AS second_valk,
      '[' || GROUP_CONCAT('"' || abyssboss_teamrec.third_valk ||'"') || ']' AS third_valk,
      '[' || GROUP_CONCAT('"' || abyssboss_teamrec.elf ||'"') || ']' AS elf,
      '[' || GROUP_CONCAT('"' || abyssboss_teamrec.note ||'"') || ']' AS note
    FROM abyssbosses
    JOIN abyssboss_teamrec ON abyssbosses.id = abyssboss_teamrec.id_abyssboss
    WHERE abyssbosses.is_deleted = 0
    GROUP BY abyssbosses.id
    ORDER BY abyssbosses.ROWID
  ''');
  return data.map((e) => AbyssBossModel.fromMap(e)).toList();
}

final abyssBossProvider = ChangeNotifierProvider<AbyssBossProvider>(
  (ref) => AbyssBossProvider(),
);
