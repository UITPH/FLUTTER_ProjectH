import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElfProvider extends ChangeNotifier {
  final List<ElfModel> _elfs = [];
  List<ElfModel> get elfs => _elfs;

  ElfProvider() {
    _loadElfs();
  }

  Future<void> _loadElfs() async {
    _elfs.addAll(await loadElfsListFromDataBase());
    notifyListeners();
  }
}

Future<List<ElfModel>> loadElfsListFromDataBase() async {
  final db = await DatabaseHelper.getDatabase();
  final List<Map<String, dynamic>> data = await db.query('elfs');
  return data.map((e) => ElfModel.fromMap(e)).toList();
}

final elfProvider = ChangeNotifierProvider<ElfProvider>((ref) => ElfProvider());
