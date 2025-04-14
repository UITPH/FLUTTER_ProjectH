import 'dart:io';
import 'dart:convert';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<WeatherModel>> loadWeathersFromPath(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> jsonList = json.decode(data);
  return jsonList.map((e) => WeatherModel.fromJson(e)).toList();
}

final weatherProvider = StateProvider<List<WeatherModel>>((ref) => []);
