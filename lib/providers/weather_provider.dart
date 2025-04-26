import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class WeatherProvider extends ChangeNotifier {
  final List<WeatherModel> _weathers = [];
  List<WeatherModel> get weathers => _weathers;

  WeatherProvider() {
    _loadElfs();
  }

  Future<void> _loadElfs() async {
    _weathers.addAll(await loadWeathersListFromJson());
    notifyListeners();
  }
}

Future<List<WeatherModel>> loadWeathersListFromJson() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/json/weathers.json');
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => WeatherModel.fromJson(e)).toList();
}

final weatherProvider = ChangeNotifierProvider<WeatherProvider>(
  (ref) => WeatherProvider(),
);
