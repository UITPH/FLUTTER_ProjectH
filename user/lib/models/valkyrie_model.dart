import 'dart:convert';

class ValkyrieModel {
  final String id;
  final String name;
  final int astralop;
  final List damage;
  final int type;
  final List equipment;
  final List lineup;
  final String role;
  final String pullrec;
  final String rankup;

  ValkyrieModel({
    required this.id,
    required this.name,
    required this.astralop,
    required this.damage,
    required this.type,
    required this.equipment,
    required this.lineup,
    required this.role,
    required this.pullrec,
    required this.rankup,
  });

  factory ValkyrieModel.fromMap(Map<String, dynamic> map) {
    return ValkyrieModel(
      id: map['id'],
      name: map['name'],
      astralop: map['astralop'],
      damage: jsonDecode(map['damage']),
      type: map['type'],
      equipment: jsonDecode(map['equipment']),
      lineup: map['valk_lineup'],
      role: map['role'],
      pullrec: map['pullrec'],
      rankup: map['rankup'],
    );
  }
}
