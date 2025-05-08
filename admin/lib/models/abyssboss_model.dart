class AbyssBossModel {
  final String id;
  final String name;
  final String idWeather;
  final String mechanic;
  final String resistance;
  final List teamrec;

  AbyssBossModel({
    required this.id,
    required this.name,
    required this.idWeather,
    required this.mechanic,
    required this.resistance,
    required this.teamrec,
  });

  factory AbyssBossModel.fromMap(Map<String, dynamic> map) {
    return AbyssBossModel(
      id: map['id'],
      name: map['name'],
      idWeather: map['id_weather'],
      mechanic: map['mechanic'],
      resistance: map['resistance'],
      teamrec: map['abyssboss_teamrec'],
    );
  }

  Map<String, dynamic> toBossMap() {
    return ({
      'id': id,
      'name': name,
      'id_weather': idWeather,
      'mechanic': mechanic,
      'resistance': resistance,
      'is_deleted': 0,
    });
  }

  List toTeamrecListMap() {
    final List<Map<String, dynamic>> res = [];
    for (var team in teamrec) {
      res.add({
        'id_abyssboss': id,
        'first_valk': team['first_valk'],
        'second_valk': team['second_valk'],
        'third_valk': team['third_valk'],
        'elf': team['elf'],
        'note': team['note'],
      });
    }
    return res;
  }
}
