import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteNotifier extends ChangeNotifier {
  final List<ValkyrieModel> _valkDeletes = [];
  final List<AbyssBossModel> _abyssbossDeletes = [];
  final List<ArenaBossModel> _arenabossDeletes = [];

  List<ValkyrieModel> get valkDeletes => _valkDeletes;
  List<AbyssBossModel> get abyssbossDeletes => _abyssbossDeletes;
  List<ArenaBossModel> get arenabossDeletes => _arenabossDeletes;

  DeleteNotifier() {
    _loadDeletes();
  }

  void init() {}

  Future<void> _loadDeletes() async {
    _valkDeletes.addAll(await loadDeleteValkModelList());
    _abyssbossDeletes.addAll(await loadDeleteAbyssBossModelList());
    _arenabossDeletes.addAll(await loadDeleteArenaBossModelList());
    notifyListeners(); // Thông báo UI cập nhật sau khi tải dữ liệu
  }

  Future<void> addValk(ValkyrieModel valk) async {
    _valkDeletes.add(valk);
    notifyListeners();
  }

  Future<void> deleteValk(String id) async {
    _valkDeletes.removeWhere((valk) => valk.id == id);
    notifyListeners();
  }

  Future<void> addAbyssBoss(AbyssBossModel boss) async {
    _abyssbossDeletes.add(boss);
    notifyListeners();
  }

  Future<void> deleteAbyssBoss(String id) async {
    _abyssbossDeletes.removeWhere((boss) => boss.id == id);
    notifyListeners();
  }

  Future<void> addArenaBoss(ArenaBossModel boss) async {
    _arenabossDeletes.add(boss);
    notifyListeners();
  }

  Future<void> deleteArenaBoss(String id) async {
    _arenabossDeletes.removeWhere((valk) => valk.id == id);
    notifyListeners();
  }
}

Future<List<ValkyrieModel>> loadDeleteValkModelList() async {
  final db = await DatabaseHelper.getDatabase();
  final List<Map<String, dynamic>> data = await db.rawQuery('''
    SELECT
      valkyries.id,
      valkyries.name,
      valkyries.astralop,
      valkyries.damage,
      valkyries.type,
      valkyries.equipment,
      '[' || GROUP_CONCAT('"' || valk_lineup.note ||'"') || ']' AS note,
      '[' || GROUP_CONCAT('"' || valk_lineup.leader ||'"') || ']' AS leader,
      '[' || GROUP_CONCAT(valk_lineup.first_valk_list) || ']' AS first_valk_list,
      '[' || GROUP_CONCAT(valk_lineup.second_valk_list) || ']' AS second_valk_list,
      '[' || GROUP_CONCAT(valk_lineup.elf_list) || ']' AS elf_list
    FROM valkyries
    JOIN valk_lineup ON valkyries.id = valk_lineup.id_valk
	  WHERE valkyries.is_deleted = 1
    GROUP BY valkyries.id
    ORDER BY valkyries.ROWID
''');
  return data.map((e) => ValkyrieModel.fromMap(e)).toList();
}

Future<List<AbyssBossModel>> loadDeleteAbyssBossModelList() async {
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
    WHERE abyssbosses.is_deleted = 1
    GROUP BY abyssbosses.id
    ORDER BY abyssbosses.ROWID
  ''');
  return data.map((e) => AbyssBossModel.fromMap(e)).toList();
}

Future<List<ArenaBossModel>> loadDeleteArenaBossModelList() async {
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
      WHERE arenabosses.is_deleted = 1
      GROUP BY arenabosses.id
      ORDER BY arenabosses.ROWID
  ''');
  return data.map((e) => ArenaBossModel.fromMap(e)).toList();
}

final deleteProvider = ChangeNotifierProvider<DeleteNotifier>(
  (ref) => DeleteNotifier(),
);
