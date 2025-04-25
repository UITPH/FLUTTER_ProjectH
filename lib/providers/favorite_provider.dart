import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<String> _valkFavorites = [];
  final List<String> _bossFavorites = [];

  List<String> get valkFavorites => _valkFavorites;
  List<String> get bossFavorites => _bossFavorites;

  FavoriteNotifier() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _valkFavorites.addAll(await loadFavoriteValkIDList());
    _bossFavorites.addAll(await loadFavoriteBossIDList());
    notifyListeners(); // Thông báo UI cập nhật sau khi tải dữ liệu
  }

  bool isValkFavorite(String newID) {
    return _valkFavorites.any((id) => id == newID);
  }

  bool isBossFavorite(String newID) {
    return _bossFavorites.any((id) => id == newID);
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

  void toggleBoss(String newID) async {
    if (isBossFavorite(newID)) {
      _bossFavorites.removeWhere((id) => id == newID);
    } else {
      _bossFavorites.add(newID);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Honkai Station/favorite/boss_favorite.txt');
    await file.writeAsString(jsonEncode(_bossFavorites));
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

Future<List<String>> loadFavoriteBossIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/favorite/boss_favorite.txt');
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
