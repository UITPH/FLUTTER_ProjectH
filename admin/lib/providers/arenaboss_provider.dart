import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenabossProvider extends ChangeNotifier {
  final List<ArenaBossModel> _bosses = [];
  List<ArenaBossModel> get bosses => _bosses;
  bool _isLoaded = false;

  ArenabossProvider() {
    _loadBosses();
  }

  Future<void> _loadBosses() async {
    _bosses.addAll(await loadBossesListFromDataBase());
    _isLoaded = true;
    notifyListeners();
  }

  void addBoss(ArenaBossModel newBoss) {
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
        arenabosses.id,
        arenabosses.name,
        arenabosses.rank,
          '[' || GROUP_CONCAT('"' || arenaboss_teamrec.first_valk ||'"') || ']' AS first_valk,
          '[' || GROUP_CONCAT('"' || arenaboss_teamrec.second_valk ||'"') || ']' AS second_valk,
          '[' || GROUP_CONCAT('"' || arenaboss_teamrec.third_valk ||'"') || ']' AS third_valk,
          '[' || GROUP_CONCAT('"' || arenaboss_teamrec.elf ||'"') || ']' AS elf
        FROM arenabosses
        JOIN arenaboss_teamrec ON arenabosses.id = arenaboss_teamrec.id_arenaboss
        WHERE arenabosses.id = ?
        GROUP BY arenabosses.id
''',
      [id],
    );
    _bosses.add(ArenaBossModel.fromMap(data[0]));
    notifyListeners();
  }
}

Future<List<ArenaBossModel>> loadBossesListFromDataBase() async {
  final db = await DatabaseHelper.getDatabase();
  final List<Map<String, dynamic>> data = await db.rawQuery('''
    SELECT
      arenabosses.id,
      arenabosses.name,
      arenabosses.rank,
        '[' || GROUP_CONCAT('"' || arenaboss_teamrec.first_valk ||'"') || ']' AS first_valk,
        '[' || GROUP_CONCAT('"' || arenaboss_teamrec.second_valk ||'"') || ']' AS second_valk,
        '[' || GROUP_CONCAT('"' || arenaboss_teamrec.third_valk ||'"') || ']' AS third_valk,
        '[' || GROUP_CONCAT('"' || arenaboss_teamrec.elf ||'"') || ']' AS elf
      FROM arenabosses
      JOIN arenaboss_teamrec ON arenabosses.id = arenaboss_teamrec.id_arenaboss
      WHERE arenabosses.is_deleted = 0
      GROUP BY arenabosses.id
      ORDER BY arenabosses.ROWID
  ''');
  return data.map((e) => ArenaBossModel.fromMap(e)).toList();
}

final arenabossProvider = ChangeNotifierProvider<ArenabossProvider>(
  (ref) => ArenabossProvider(),
);
