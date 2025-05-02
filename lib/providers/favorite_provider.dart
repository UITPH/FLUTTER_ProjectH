import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<String> _valkFavorites = [];
  final List<String> _abyssbossFavorites = [];
  final List<String> _arenabossFavorites = [];

  List<String> get valkFavorites => _valkFavorites;
  List<String> get abyssbossFavorites => _abyssbossFavorites;
  List<String> get arenabossFavorites => _arenabossFavorites;

  FavoriteNotifier() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _valkFavorites.addAll(await loadFavoriteValkIDList());
    _abyssbossFavorites.addAll(await loadFavoriteAbyssBossIDList());
    _arenabossFavorites.addAll(await loadFavoriteArenaBossIDList());
    notifyListeners(); // Thông báo UI cập nhật sau khi tải dữ liệu
  }

  bool isValkFavorite(String newID) {
    return _valkFavorites.any((id) => id == newID);
  }

  bool isAbyssBossFavorite(String newID) {
    return _abyssbossFavorites.any((id) => id == newID);
  }

  bool isArenaBossFavorite(String newID) {
    return _arenabossFavorites.any((id) => id == newID);
  }

  Future<void> toggleValk(String newID) async {
    if (isValkFavorite(newID)) {
      _valkFavorites.removeWhere((id) => id == newID);
    } else {
      _valkFavorites.add(newID);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Honkai Station/favorite/valk_favorite.txt');
    await file.writeAsString(jsonEncode(_valkFavorites));
    notifyListeners();
  }

  void toggleAbyssBoss(String newID) async {
    if (isAbyssBossFavorite(newID)) {
      _abyssbossFavorites.removeWhere((id) => id == newID);
    } else {
      _abyssbossFavorites.add(newID);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/Honkai Station/favorite/abyssboss_favorite.txt',
    );
    await file.writeAsString(jsonEncode(_abyssbossFavorites));
    notifyListeners();
  }

  void toggleArenaBoss(String newID) async {
    if (isArenaBossFavorite(newID)) {
      _arenabossFavorites.removeWhere((id) => id == newID);
    } else {
      _arenabossFavorites.add(newID);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      '${dir.path}/Honkai Station/favorite/arenaboss_favorite.txt',
    );
    await file.writeAsString(jsonEncode(_arenabossFavorites));
    notifyListeners();
  }
}

Future<List<String>> loadFavoriteValkIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/favorite/valk_favorite.txt');
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> favoriteValkyries = jsonDecode(data);
  return favoriteValkyries.cast<String>();
}

Future<List<String>> loadFavoriteAbyssBossIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(
    '${dir.path}/Honkai Station/favorite/abyssboss_favorite.txt',
  );
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> favoriteBosses = jsonDecode(data);
  return favoriteBosses.cast<String>();
}

Future<List<String>> loadFavoriteArenaBossIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(
    '${dir.path}/Honkai Station/favorite/arenaboss_favorite.txt',
  );
  if (!await file.exists()) {
    return [];
  }
  final data = await file.readAsString();
  final List<dynamic> favoriteBosses = jsonDecode(data);
  return favoriteBosses.cast<String>();
}

final favoriteProvider = ChangeNotifierProvider<FavoriteNotifier>(
  (ref) => FavoriteNotifier(),
);
