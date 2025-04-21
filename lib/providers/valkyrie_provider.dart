import 'dart:io';
import 'dart:convert';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

Future<List<ValkyrieModel>> loadValkyriesListFromJson() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/valkyries.json');
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => ValkyrieModel.fromJson(e)).toList();
}

Future<void> saveValkyriesListToJson(List<ValkyrieModel> valkyries) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/valkyries.json');
  List<Map<String, dynamic>> jsonList =
      valkyries.map((e) => e.toJson()).toList();
  final String data = JsonEncoder.withIndent('    ').convert(jsonList);
  await file.writeAsString(data);
}

final valkyrieProvider = StateProvider<List<ValkyrieModel>>((ref) => []);
