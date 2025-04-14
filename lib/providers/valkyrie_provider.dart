import 'dart:io';
import 'dart:convert';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<ValkyrieModel>> loadValkyriesFromPath(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => ValkyrieModel.fromJson(e)).toList();
}

final valkyrieProvider = StateProvider<List<ValkyrieModel>>((ref) => []);
