class ArenaBossModel {
  final String id;
  final String name;
  final int rank;
  final List teamrec;
  final String version;

  ArenaBossModel({
    required this.id,
    required this.name,
    required this.rank,
    required this.teamrec,
    required this.version,
  });

  factory ArenaBossModel.fromMap(Map<String, dynamic> map) {
    return ArenaBossModel(
      id: map['id'],
      name: map['name'],
      rank: map['rank'],
      teamrec: map['arenaboss_teamrec'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toBossMap() {
    return ({
      'id': id,
      'name': name,
      'rank': rank,
      'is_deleted': 0,
      'version': version,
    });
  }

  List toTeamrecListMap() {
    final List<Map<String, dynamic>> res = [];
    for (var team in teamrec) {
      res.add({
        'id_arenaboss': id,
        'first_valk': team['first_valk'],
        'second_valk': team['second_valk'],
        'third_valk': team['third_valk'],
        'elf': team['elf'],
      });
    }
    return res;
  }
}
