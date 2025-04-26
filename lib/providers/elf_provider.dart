import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class ElfProvider extends ChangeNotifier {
  final List<ElfModel> _elfs = [];
  List<ElfModel> get elfs => _elfs;

  ElfProvider() {
    _loadElfs();
  }

  Future<void> _loadElfs() async {
    _elfs.addAll(await loadElfsListFromJson());
    notifyListeners();
  }
}

Future<List<ElfModel>> loadElfsListFromJson() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/elfs.json');
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => ElfModel.fromJson(e)).toList();
}

final elfProvider = ChangeNotifierProvider<ElfProvider>((ref) => ElfProvider());
