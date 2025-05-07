import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<String> _valkFavorites = [];
  final List<String> _elfFavorites = [];
  final List<String> _abyssbossFavorites = [];
  final List<String> _arenabossFavorites = [];

  List<String> get valkFavorites => _valkFavorites;
  List<String> get elfFavorites => _elfFavorites;
  List<String> get abyssbossFavorites => _abyssbossFavorites;
  List<String> get arenabossFavorites => _arenabossFavorites;

  FavoriteNotifier() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _valkFavorites.addAll(await loadFavoriteValkIDList());
    _elfFavorites.addAll(await loadFavoriteElfIDList());
    _abyssbossFavorites.addAll(await loadFavoriteAbyssBossIDList());
    _arenabossFavorites.addAll(await loadFavoriteArenaBossIDList());
    notifyListeners(); // Thông báo UI cập nhật sau khi tải dữ liệu
  }

  bool isValkFavorite(String newID) {
    return _valkFavorites.any((id) => id == newID);
  }

  bool isElfFavorite(String newID) {
    return _elfFavorites.any((id) => id == newID);
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
    final file = File(
      '${dir.path}/Honkai Station/favorite/favorite_valkyries.txt',
    );
    await file.writeAsString(jsonEncode(_valkFavorites));
    notifyListeners();
  }

  Future<void> toggleElf(String newID) async {
    if (isElfFavorite(newID)) {
      _elfFavorites.removeWhere((id) => id == newID);
    } else {
      _elfFavorites.add(newID);
    }
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Honkai Station/favorite/favorite_elfs.txt');
    await file.writeAsString(jsonEncode(_elfFavorites));
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
      '${dir.path}/Honkai Station/favorite/favorite_abyssbosses.txt',
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
      '${dir.path}/Honkai Station/favorite/favorite_arenabosses.txt',
    );
    await file.writeAsString(jsonEncode(_arenabossFavorites));
    notifyListeners();
  }
}

Future<List<String>> loadFavoriteValkIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(
    '${dir.path}/Honkai Station/favorite/favorite_valkyries.txt',
  );
  return jsonDecode(await file.readAsString()).cast<String>();
}

Future<List<String>> loadFavoriteElfIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/Honkai Station/favorite/favorite_elfs.txt');
  return jsonDecode(await file.readAsString()).cast<String>();
}

Future<List<String>> loadFavoriteAbyssBossIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(
    '${dir.path}/Honkai Station/favorite/favorite_abyssbosses.txt',
  );
  return jsonDecode(await file.readAsString()).cast<String>();
}

Future<List<String>> loadFavoriteArenaBossIDList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(
    '${dir.path}/Honkai Station/favorite/favorite_arenabosses.txt',
  );
  return jsonDecode(await file.readAsString()).cast<String>();
}

final favoriteProvider = ChangeNotifierProvider<FavoriteNotifier>(
  (ref) => FavoriteNotifier(),
);
