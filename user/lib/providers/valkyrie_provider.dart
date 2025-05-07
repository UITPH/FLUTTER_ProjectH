import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ValkyrieProvider extends ChangeNotifier {
  final List<ValkyrieModel> _valkyries = [];
  List<ValkyrieModel> get valkyries => _valkyries;

  Future<void> loadValkyries() async {
    _valkyries.addAll(await loadValkyriesListFromDataBase());
    notifyListeners();
  }
}

Future<List<ValkyrieModel>> loadValkyriesListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('valkyries')
      .select(
        'id, name, astralop, damage, type, equipment, valk_lineup(note, leader, first_valk_list, second_valk_list, elf_list), role, pullrec, rankup',
      )
      .order('order', ascending: true);
  return data.map((e) => ValkyrieModel.fromMap(e)).toList();
}

final valkyrieProvider = ChangeNotifierProvider<ValkyrieProvider>(
  (ref) => ValkyrieProvider(),
);
