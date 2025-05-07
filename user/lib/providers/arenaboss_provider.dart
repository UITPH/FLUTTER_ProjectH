import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenabossProvider extends ChangeNotifier {
  final List<ArenaBossModel> _bosses = [];
  List<ArenaBossModel> get bosses => _bosses;

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
      );
  return data.map((e) => ArenaBossModel.fromMap(e)).toList();
}

final arenabossProvider = ChangeNotifierProvider<ArenabossProvider>(
  (ref) => ArenabossProvider(),
);
