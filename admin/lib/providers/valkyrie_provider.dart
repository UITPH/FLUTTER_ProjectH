import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieProvider extends ChangeNotifier {
  final List<ValkyrieModel> _valkyries = [];
  List<ValkyrieModel> get valkyries => _valkyries;

  void addValkyrie(ValkyrieModel newValk) {
    _valkyries.insert(0, newValk);
    notifyListeners();
  }

  void removeValkyrie(String id) {
    _valkyries.removeWhere((valk) => valk.id == id);
    notifyListeners();
  }

  Future<void> loadValkyries() async {
    _valkyries.addAll(await loadValkyriesListFromDataBase());
    notifyListeners();
  }
}

Future<List<ValkyrieModel>> loadValkyriesListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('valkyries')
      .select('''
        id, name, astralop, damage, type, equipment, role, pullrec, rankup, version,
        lineup:lineup!id_owner_valk(
          id, name, leader, 
          lineup_first_valk_list(id_valk), 
          lineup_second_valk_list(id_valk),
          lineup_elf_list(id_elf)
        )
        ''')
      .eq('is_deleted', 0)
      .order('order', ascending: false);
  return data.map((e) => ValkyrieModel.fromMap(e)).toList();
}

final valkyrieProvider = ChangeNotifierProvider<ValkyrieProvider>(
  (ref) => ValkyrieProvider(),
);
