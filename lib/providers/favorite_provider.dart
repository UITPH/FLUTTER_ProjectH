import 'package:flutter/material.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      final db = await DatabaseHelper.getDatabase();
      await db.delete(
        'favorite_valkyries',
        where: 'id_valk = ?',
        whereArgs: [newID],
      );
    } else {
      _valkFavorites.add(newID);
      final db = await DatabaseHelper.getDatabase();
      await db.insert('favorite_valkyries', {'id_valk': newID});
    }

    notifyListeners();
  }

  Future<void> toggleElf(String newID) async {
    if (isElfFavorite(newID)) {
      _elfFavorites.removeWhere((id) => id == newID);
      final db = await DatabaseHelper.getDatabase();
      await db.delete('favorite_elfs', where: 'id_elf = ?', whereArgs: [newID]);
    } else {
      _elfFavorites.add(newID);
      final db = await DatabaseHelper.getDatabase();
      await db.insert('favorite_elfs', {'id_elf': newID});
    }

    notifyListeners();
  }

  void toggleAbyssBoss(String newID) async {
    if (isAbyssBossFavorite(newID)) {
      _abyssbossFavorites.removeWhere((id) => id == newID);
      final db = await DatabaseHelper.getDatabase();
      await db.delete(
        'favorite_abyssbosses',
        where: 'id_boss = ?',
        whereArgs: [newID],
      );
    } else {
      _abyssbossFavorites.add(newID);
      final db = await DatabaseHelper.getDatabase();
      await db.insert('favorite_abyssbosses', {'id_boss': newID});
    }

    notifyListeners();
  }

  void toggleArenaBoss(String newID) async {
    if (isArenaBossFavorite(newID)) {
      _arenabossFavorites.removeWhere((id) => id == newID);
      final db = await DatabaseHelper.getDatabase();
      await db.delete(
        'favorite_arenabosses',
        where: 'id_boss = ?',
        whereArgs: [newID],
      );
    } else {
      _arenabossFavorites.add(newID);
      final db = await DatabaseHelper.getDatabase();
      await db.insert('favorite_arenabosses', {'id_boss': newID});
    }

    notifyListeners();
  }
}

Future<List<String>> loadFavoriteValkIDList() async {
  final db = await DatabaseHelper.getDatabase();
  final data = await db.query('favorite_valkyries');
  return data.map((e) => e['id_valk'] as String).toList();
}

Future<List<String>> loadFavoriteElfIDList() async {
  final db = await DatabaseHelper.getDatabase();
  final data = await db.query('favorite_elfs');
  return data.map((e) => e['id_elf'] as String).toList();
}

Future<List<String>> loadFavoriteAbyssBossIDList() async {
  final db = await DatabaseHelper.getDatabase();
  final data = await db.query('favorite_abyssbosses');
  return data.map((e) => e['id_boss'] as String).toList();
}

Future<List<String>> loadFavoriteArenaBossIDList() async {
  final db = await DatabaseHelper.getDatabase();
  final data = await db.query('favorite_arenabosses');
  return data.map((e) => e['id_boss'] as String).toList();
}

final favoriteProvider = ChangeNotifierProvider<FavoriteNotifier>(
  (ref) => FavoriteNotifier(),
);
