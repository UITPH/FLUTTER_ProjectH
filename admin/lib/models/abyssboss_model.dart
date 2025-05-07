import 'dart:convert';

class AbyssBossModel {
  final String id;
  final String name;
  final String idWeather;
  final String mechanic;
  final String resistance;
  final List firstValk;
  final List secondValk;
  final List thirdValk;
  final List elf;
  final List note;

  AbyssBossModel({
    required this.id,
    required this.name,
    required this.idWeather,
    required this.mechanic,
    required this.resistance,
    required this.firstValk,
    required this.secondValk,
    required this.thirdValk,
    required this.elf,
    required this.note,
  });

  factory AbyssBossModel.fromMap(Map<String, dynamic> map) {
    return AbyssBossModel(
      id: map['id'],
      name: map['name'],
      idWeather: map['id_weather'],
      mechanic: map['mechanic'],
      resistance: map['resistance'],
      firstValk: jsonDecode(map['first_valk']),
      secondValk: jsonDecode(map['second_valk']),
      thirdValk: jsonDecode(map['third_valk']),
      elf: jsonDecode(map['elf']),
      note: jsonDecode(map['note']),
    );
  }

  Map<String, dynamic> toMainMap() {
    return {
      'id': id,
      'name': name,
      'id_weather': idWeather,
      'mechanic': mechanic,
      'resistance': resistance,
      'is_deleted': 0,
    };
  }

  List<Map<String, dynamic>> toTeamrecListMap() {
    List<Map<String, dynamic>> res = [];
    for (int i = 0; i < firstValk.length; i++) {
      res.add({
        'id_abyssboss': id,
        'first_valk': firstValk[i],
        'second_valk': secondValk[i],
        'third_valk': thirdValk[i],
        'elf': elf[i],
        'note': note[i],
      });
    }
    return res;
  }
}
