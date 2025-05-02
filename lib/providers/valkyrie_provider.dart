import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieProvider extends ChangeNotifier {
  final List<ValkyrieModel> _valkyries = [];
  List<ValkyrieModel> get valkyries => _valkyries;
  bool _isLoaded = false;

  ValkyrieProvider() {
    _loadValkyries();
  }

  Future<void> _loadValkyries() async {
    _valkyries.addAll(await loadValkyriesListFromDataBase());
    _isLoaded = true;
    notifyListeners();
  }

  void addValkyrie(ValkyrieModel newValkyrie) {
    if (_isLoaded == false) return;
    _valkyries.add(newValkyrie);
    notifyListeners();
  }

  void removeValkyrie(String id) {
    if (_isLoaded == false) return;
    _valkyries.removeWhere((valk) => valk.id == id);
    notifyListeners();
  }

  void restoreValkyrie(String id) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> data = await db.rawQuery(
      '''
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
	  WHERE valkyries.id = ?
    GROUP BY valkyries.id
''',
      [id],
    );
    _valkyries.add(ValkyrieModel.fromMap(data[0]));
    notifyListeners();
  }
}

Future<List<ValkyrieModel>> loadValkyriesListFromDataBase() async {
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
	  WHERE valkyries.is_deleted = 0
    GROUP BY valkyries.id
    ORDER BY valkyries.ROWID
''');
  return data.map((e) => ValkyrieModel.fromMap(e)).toList();
}

final valkyrieProvider = ChangeNotifierProvider<ValkyrieProvider>(
  (ref) => ValkyrieProvider(),
);
