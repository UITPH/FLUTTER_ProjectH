import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherProvider extends ChangeNotifier {
  final List<WeatherModel> _weathers = [];
  List<WeatherModel> get weathers => _weathers;

  Future<void> loadWeathers() async {
    _weathers.addAll(await loadWeathersListFromDataBase());
    notifyListeners();
  }
}

Future<List<WeatherModel>> loadWeathersListFromDataBase() async {
  final db = DatabaseHelper.supabase;
  final data = await db.from('weathers').select();
  return data.map((e) => WeatherModel.fromMap(e)).toList();
}

final weatherProvider = ChangeNotifierProvider<WeatherProvider>(
  (ref) => WeatherProvider(),
);
