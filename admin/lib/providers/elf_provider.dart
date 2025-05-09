import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfProvider extends ChangeNotifier {
  final List<ElfModel> _elfs = [];
  List<ElfModel> get elfs => _elfs;

  void addElf(ElfModel newElf) {
    _elfs.insert(0, newElf);
    notifyListeners();
  }

  void removeElf(String id) {
    _elfs.removeWhere((elf) => elf.id == id);
    notifyListeners();
  }

  Future<void> loadElfs() async {
    _elfs.addAll(await loadElfsListFromDataBase());
    notifyListeners();
  }
}

Future<List<ElfModel>> loadElfsListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('elfs')
      .select()
      .eq('is_deleted', 0)
      .order('order', ascending: false);
  return data.map((e) => ElfModel.fromMap(e)).toList();
}

final elfProvider = ChangeNotifierProvider<ElfProvider>((ref) => ElfProvider());
