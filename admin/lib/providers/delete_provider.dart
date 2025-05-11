import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteNotifier extends ChangeNotifier {
  final List<ValkyrieModel> _valkDeletes = [];
  final List<AbyssBossModel> _abyssbossDeletes = [];
  final List<ArenaBossModel> _arenabossDeletes = [];
  final List<ElfModel> _elfDeletes = [];

  List<ValkyrieModel> get valkDeletes => _valkDeletes;
  List<AbyssBossModel> get abyssbossDeletes => _abyssbossDeletes;
  List<ArenaBossModel> get arenabossDeletes => _arenabossDeletes;
  List<ElfModel> get elfDeletes => _elfDeletes;

  DeleteNotifier() {
    _loadDeletes();
  }

  void init() {}

  Future<void> _loadDeletes() async {
    _valkDeletes.addAll(await loadDeleteValkModelList());
    _abyssbossDeletes.addAll(await loadDeleteAbyssBossModelList());
    _arenabossDeletes.addAll(await loadDeleteArenaBossModelList());
    _elfDeletes.addAll(await loadDeleteElfModelList());
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

  Future<void> restoreValk(String id, WidgetRef ref) async {
    final valk = _valkDeletes.firstWhere((valk) => valk.id == id);
    ref.read(valkyrieProvider).addValkyrie(valk);
    _valkDeletes.remove(valk);
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

  Future<void> restoreAbyssBoss(String id, WidgetRef ref) async {
    final boss = _abyssbossDeletes.firstWhere((boss) => boss.id == id);
    ref.read(abyssBossProvider).addBoss(boss);
    _abyssbossDeletes.remove(boss);
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

  Future<void> restoreArenaBoss(String id, WidgetRef ref) async {
    final boss = _arenabossDeletes.firstWhere((boss) => boss.id == id);
    ref.read(arenabossProvider).addBoss(boss);
    _arenabossDeletes.remove(boss);
    notifyListeners();
  }

  Future<void> addElf(ElfModel elf) async {
    _elfDeletes.add(elf);
    notifyListeners();
  }

  Future<void> deleteElf(String id) async {
    _elfDeletes.removeWhere((elf) => elf.id == id);
    notifyListeners();
  }

  Future<void> restoreElf(String id, WidgetRef ref) async {
    final elf = _elfDeletes.firstWhere((elf) => elf.id == id);
    ref.read(elfProvider).addElf(elf);
    _elfDeletes.remove(elf);
    notifyListeners();
  }
}

Future<List<ValkyrieModel>> loadDeleteValkModelList() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('valkyries')
      .select('''
        id, name, astralop, damage, type, equipment, role, pullrec, rankup,
        lineup:lineup!id_owner_valk(
          id, name, leader, 
          lineup_first_valk_list(id_valk), 
          lineup_second_valk_list(id_valk),
          lineup_elf_list(id_elf)
        )
        ''')
      .eq('is_deleted', 1)
      .order('order', ascending: false);
  return data.map((e) => ValkyrieModel.fromMap(e)).toList();
}

Future<List<AbyssBossModel>> loadDeleteAbyssBossModelList() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('abyssbosses')
      .select(
        'id, name, id_weather, mechanic, resistance, abyssboss_teamrec(first_valk, second_valk, third_valk, elf, note)',
      )
      .eq('is_deleted', 1)
      .order('order', ascending: false);
  return data.map((e) => AbyssBossModel.fromMap(e)).toList();
}

Future<List<ArenaBossModel>> loadDeleteArenaBossModelList() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('arenabosses')
      .select(
        'id, name, rank, arenaboss_teamrec(first_valk, second_valk, third_valk, elf)',
      )
      .eq('is_deleted', 1)
      .order('order', ascending: false);
  return data.map((e) => ArenaBossModel.fromMap(e)).toList();
}

Future<List<ElfModel>> loadDeleteElfModelList() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('elfs')
      .select()
      .eq('is_deleted', 1)
      .order('order', ascending: false);
  return data.map((e) => ElfModel.fromMap(e)).toList();
}

final deleteProvider = ChangeNotifierProvider<DeleteNotifier>(
  (ref) => DeleteNotifier(),
);
