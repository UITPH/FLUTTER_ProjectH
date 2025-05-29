import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/parameter_model.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParameterProvider extends ChangeNotifier {
  late ParameterModel _parameters;
  ParameterModel get parameters => _parameters;

  Future<void> loadParameters() async {
    _parameters = await loadParametersfromDatabase();
    notifyListeners();
  }

  void changeParameters({
    required int isMaintainance,
    required String maintainanceInfo,
  }) {
    _parameters.isMaintainance = isMaintainance;
    _parameters.maintainanceInfo = maintainanceInfo;
  }
}

Future<ParameterModel> loadParametersfromDatabase() async {
  final db = DatabaseHelper.supabase;
  final data = await db
      .from('parameters')
      .select('key, value')
      .order('order', ascending: true);
  return ParameterModel.fromListMap(data);
}

final parameterProvider = ChangeNotifierProvider<ParameterProvider>(
  (ref) => ParameterProvider(),
);
