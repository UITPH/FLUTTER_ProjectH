import 'package:flutter/material.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageVersionProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _valkyries = [];
  final List<Map<String, dynamic>> _abyssbosses = [];
  final List<Map<String, dynamic>> _arenabosses = [];
  final List<Map<String, dynamic>> _elfs = [];
  List<Map<String, dynamic>> get valkyries => _valkyries;
  List<Map<String, dynamic>> get elfs => _elfs;
  List<Map<String, dynamic>> get abyssbosses => _abyssbosses;
  List<Map<String, dynamic>> get arenabosses => _arenabosses;

  void addValkyrie(String id, String version) {
    _valkyries.add({'id': id, 'version': version});
    notifyListeners();
  }

  void addElf(String id, String version) {
    _elfs.add({'id': id, 'version': version});
    notifyListeners();
  }

  void addAbyssBoss(String id, String version) {
    _abyssbosses.add({'id': id, 'version': version});
    notifyListeners();
  }

  void addArenaBoss(String id, String version) {
    _arenabosses.add({'id': id, 'version': version});
    notifyListeners();
  }

  void modifyValkyrie(String id, String version) {
    int index = _valkyries.indexWhere((valk) => valk['id'] == id);
    _valkyries[index]['version'] = version;
  }

  void modifyElf(String id, String version) {
    int index = _elfs.indexWhere((elf) => elf['id'] == id);
    _elfs[index]['version'] = version;
  }

  void modifyAbyssBoss(String id, String version) {
    int index = _abyssbosses.indexWhere((boss) => boss['id'] == id);
    _abyssbosses[index]['version'] = version;
  }

  void modifyArenaBoss(String id, String version) {
    int index = _arenabosses.indexWhere((boss) => boss['id'] == id);
    _arenabosses[index]['version'] = version;
  }

  void removeValkyrie(String id) {
    _valkyries.removeWhere((valk) => valk['id'] == id);
    notifyListeners();
  }

  void removeElf(String id) {
    _elfs.removeWhere((boss) => boss['id'] == id);
    notifyListeners();
  }

  void removeAbyssBoss(String id) {
    _abyssbosses.removeWhere((boss) => boss['id'] == id);
    notifyListeners();
  }

  void removeArenaBoss(String id) {
    _arenabosses.removeWhere((boss) => boss['id'] == id);
    notifyListeners();
  }

  Future<void> loadValkyries() async {
    _valkyries.addAll(await loadValkyrieImagesVersionList());
    notifyListeners();
  }

  Future<void> loadElfs() async {
    _elfs.addAll(await loadElfImagesVersionList());
    notifyListeners();
  }

  Future<void> loadAbyssBosses() async {
    _abyssbosses.addAll(await loadAbyssBossImagesVersionList());
    notifyListeners();
  }

  Future<void> loadArenaBosses() async {
    _arenabosses.addAll(await loadArenaBossImagesVersionList());
    notifyListeners();
  }
}

Future<List<Map<String, dynamic>>> loadValkyrieImagesVersionList() async {
  final db = DatabaseHelper.supabase;
  final data = await db.from('valkyries_image_version').select();
  return data;
}

Future<List<Map<String, dynamic>>> loadElfImagesVersionList() async {
  final db = DatabaseHelper.supabase;
  final data = await db.from('elfs_image_version').select();
  return data;
}

Future<List<Map<String, dynamic>>> loadAbyssBossImagesVersionList() async {
  final db = DatabaseHelper.supabase;
  final data = await db.from('abyssbosses_image_version').select();
  return data;
}

Future<List<Map<String, dynamic>>> loadArenaBossImagesVersionList() async {
  final db = DatabaseHelper.supabase;
  final data = await db.from('arenabosses_image_version').select();
  return data;
}

final imageVersionProvider = ChangeNotifierProvider<ImageVersionProvider>(
  (ref) => ImageVersionProvider(),
);
