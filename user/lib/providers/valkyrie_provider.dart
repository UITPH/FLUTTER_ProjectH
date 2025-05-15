import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieProvider extends ChangeNotifier {
  final List<ValkyrieModel> _valkyries = [];
  List<ValkyrieModel> get valkyries => _valkyries;

  Future<void> loadValkyries() async {
    _valkyries.clear();
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
          name, leader, 
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
