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
}
