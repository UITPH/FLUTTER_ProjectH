import 'dart:convert';
import 'dart:io';

import 'package:flutter_honkai/models/crystal_cal_model.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveCrystalHistory(CrystalCalModel data) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/crystalcalhistory.json');
  final String jsonString = JsonEncoder.withIndent(
    '    ',
  ).convert(data.toJson());
  await file.writeAsString(jsonString);
}

Future<CrystalCalModel> loadCrystalHistory() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/crystalcalhistory.json');
  final jsonString = await file.readAsString();
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  return CrystalCalModel.fromJson(jsonMap);
}
