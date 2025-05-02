import 'dart:convert';

class ArenaBossModel {
  final String id;
  final String name;
  final int rank;
  final List firstValk;
  final List secondValk;
  final List thirdValk;
  final List elf;

  ArenaBossModel({
    required this.id,
    required this.name,
    required this.rank,
    required this.firstValk,
    required this.secondValk,
    required this.thirdValk,
    required this.elf,
  });

  factory ArenaBossModel.fromMap(Map<String, dynamic> map) {
    return ArenaBossModel(
      id: map['id'],
      name: map['name'],
      rank: map['rank'],
      firstValk: jsonDecode(map['first_valk']),
      secondValk: jsonDecode(map['second_valk']),
      thirdValk: jsonDecode(map['third_valk']),
      elf: jsonDecode(map['elf']),
    );
  }

  Map<String, dynamic> toMainMap() {
    return {'id': id, 'name': name, 'rank': rank, 'is_deleted': 0};
  }

  List<Map<String, dynamic>> toTeamrecListMap() {
    List<Map<String, dynamic>> res = [];
    for (int i = 0; i < firstValk.length; i++) {
      res.add({
        'id_arenaboss': id,
        'first_valk': firstValk[i],
        'second_valk': secondValk[i],
        'third_valk': thirdValk[i],
        'elf': elf[i],
      });
    }
    return res;
  }
}
