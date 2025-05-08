import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenabossProvider extends ChangeNotifier {
  final List<ArenaBossModel> _bosses = [];
  List<ArenaBossModel> get bosses => _bosses;

  void addBoss(ArenaBossModel newBoss) {
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

Future<List<ArenaBossModel>> loadBossesListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('arenabosses')
      .select(
        'id, name, rank, arenaboss_teamrec(first_valk, second_valk, third_valk, elf)',
      )
      .eq('is_deleted', 0)
      .order('order', ascending: false);
  return data.map((e) => ArenaBossModel.fromMap(e)).toList();
}

final arenabossProvider = ChangeNotifierProvider<ArenabossProvider>(
  (ref) => ArenabossProvider(),
);
