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
  final String version;

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
    required this.version,
  });

  factory ValkyrieModel.fromMap(Map<String, dynamic> map) {
    return ValkyrieModel(
      id: map['id'],
      name: map['name'],
      astralop: map['astralop'],
      damage: jsonDecode(map['damage']),
      type: map['type'],
      equipment: jsonDecode(map['equipment']),
      lineup:
          map['lineup']
              .map(
                (x) => <String, dynamic>{
                  'id': x['id'],
                  'note': x['name'],
                  'leader': x['leader'],
                  'first_valk_list':
                      x['lineup_first_valk_list']
                          .map((y) => y['id_valk'])
                          .toList(),
                  'second_valk_list':
                      x['lineup_second_valk_list']
                          .map((y) => y['id_valk'])
                          .toList(),
                  'elf_list':
                      x['lineup_elf_list'].map((y) => y['id_elf']).toList(),
                },
              )
              .toList(),
      role: map['role'],
      pullrec: map['pullrec'],
      rankup: map['rankup'],
      version: map['version'],
    );
  }

  void addIdToLineup(List ids) {
    lineup.asMap().forEach((index, line) {
      line['id'] = ids[index]['id'];
    });
  }

  Map<String, dynamic> toValkMap() {
    return {
      'id': id,
      'name': name,
      'astralop': astralop,
      'damage': jsonEncode(damage),
      'type': type,
      'equipment': jsonEncode(equipment),
      'role': role,
      'pullrec': pullrec,
      'rankup': rankup,
      'is_deleted': 0,
      'version': version,
    };
  }

  List toLineupListMap() {
    final List<Map<String, dynamic>> res = [];
    for (var line in lineup) {
      res.add({
        'id_owner_valk': id,
        'name': line['note'],
        'leader': line['leader'],
      });
    }
    return res;
  }

  List toLineupFirstValkListMap() {
    final res = [];
    for (var line in lineup) {
      for (var valk in line['first_valk_list']) {
        res.add({'id_lineup': line['id'], 'id_valk': valk});
      }
    }
    return res;
  }

  List toLineupSecondValkListMap() {
    final res = [];
    for (var line in lineup) {
      for (var valk in line['second_valk_list']) {
        res.add({'id_lineup': line['id'], 'id_valk': valk});
      }
    }
    return res;
  }

  List toLineupElfListMap() {
    final res = [];
    for (var line in lineup) {
      for (var valk in line['elf_list']) {
        res.add({'id_lineup': line['id'], 'id_elf': valk});
      }
    }
    return res;
  }
}
