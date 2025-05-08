import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfProvider extends ChangeNotifier {
  final List<ElfModel> _elfs = [];
  List<ElfModel> get elfs => _elfs;

  Future<void> loadElfs() async {
    _elfs.addAll(await loadElfsListFromDataBase());
    notifyListeners();
  }
}

Future<List<ElfModel>> loadElfsListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db.from('elfs').select();
  return data.map((e) => ElfModel.fromMap(e)).toList();
}

final elfProvider = ChangeNotifierProvider<ElfProvider>((ref) => ElfProvider());
