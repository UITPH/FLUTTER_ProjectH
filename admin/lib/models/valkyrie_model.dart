import 'dart:convert';

class ValkyrieModel {
  final String id;
  final String name;
  final int astralop;
  final List damage;
  final int type;
  final List equipment;
  final List note;
  final List leader;
  final List firstvalkList;
  final List secondvalkList;
  final List elfList;

  ValkyrieModel({
    required this.id,
    required this.name,
    required this.astralop,
    required this.damage,
    required this.type,
    required this.equipment,
    required this.note,
    required this.leader,
    required this.firstvalkList,
    required this.secondvalkList,
    required this.elfList,
  });

  factory ValkyrieModel.fromMap(Map<String, dynamic> map) {
    return ValkyrieModel(
      id: map['id'],
      name: map['name'],
      astralop: map['astralop'],
      damage: jsonDecode(map['damage']),
      type: map['type'],
      equipment: jsonDecode(map['equipment']),
      note: jsonDecode(map['note']),
      leader: jsonDecode(map['leader']),
      firstvalkList: jsonDecode(map['first_valk_list']),
      secondvalkList: jsonDecode(map['second_valk_list']),
      elfList: jsonDecode(map['elf_list']),
    );
  }

  Map<String, dynamic> toMainMap() {
    return {
      'id': id,
      'name': name,
      'astralop': astralop,
      'damage': jsonEncode(damage),
      'type': type,
      'equipment': jsonEncode(equipment),
      'is_deleted': 0,
    };
  }

  List<Map<String, dynamic>> toLineUpListMap() {
    List<Map<String, dynamic>> res = [];
    for (int i = 0; i < note.length; i++) {
      res.add({
        'id_valk': id,
        'note': note[i],
        'leader': leader[i],
        'first_valk_list': jsonEncode(firstvalkList[i]),
        'second_valk_list': jsonEncode(secondvalkList[i]),
        'elf_list': jsonEncode(elfList[i]),
      });
    }
    return res;
  }
}
