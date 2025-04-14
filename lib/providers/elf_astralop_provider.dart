import 'dart:io';
import 'dart:convert';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<ElfModel>> loadElfsFromPath(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => ElfModel.fromJson(e)).toList();
}

final elfProvider = StateProvider<List<ElfModel>>((ref) => []);
