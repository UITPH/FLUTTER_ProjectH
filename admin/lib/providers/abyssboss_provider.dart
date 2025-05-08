import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbyssBossProvider extends ChangeNotifier {
  final List<AbyssBossModel> _bosses = [];
  List<AbyssBossModel> get bosses => _bosses;

  void addBoss(AbyssBossModel newBoss) {
    _bosses.insert(0, newBoss);
    notifyListeners();
  }

  void removeBoss(String id) {
    _bosses.removeWhere((boss) => boss.id == id);
    notifyListeners();
  }

  Future<void> loadBosses() async {
    _bosses.addAll(await loadBossesListFromDataBase());
    notifyListeners();
  }
}

Future<List<AbyssBossModel>> loadBossesListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('abyssbosses')
      .select(
        'id, name, id_weather, mechanic, resistance, abyssboss_teamrec(first_valk, second_valk, third_valk, elf, note)',
      )
      .eq('is_deleted', 0)
      .order('order', ascending: false);
  return data.map((e) => AbyssBossModel.fromMap(e)).toList();
}

final abyssBossProvider = ChangeNotifierProvider<AbyssBossProvider>(
  (ref) => AbyssBossProvider(),
);
