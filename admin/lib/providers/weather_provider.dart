import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherProvider extends ChangeNotifier {
  final List<WeatherModel> _weathers = [];
  List<WeatherModel> get weathers => _weathers;

  WeatherProvider() {
    _loadWeathers();
  }

  Future<void> _loadWeathers() async {
    _weathers.addAll(await loadWeathersListFromDataBase());
    notifyListeners();
  }
}

Future<List<WeatherModel>> loadWeathersListFromDataBase() async {
  final db = await DatabaseHelper.getDatabase();
  final List<Map<String, dynamic>> data = await db.query('weathers');
  return data.map((e) => WeatherModel.fromMap(e)).toList();
}

final weatherProvider = ChangeNotifierProvider<WeatherProvider>(
  (ref) => WeatherProvider(),
);
