class AbyssBossModel {
  final String id;
  final String name;
  final String idWeather;
  final String mechanic;
  final String resistance;
  final List teamrec;
  final String version;

  AbyssBossModel({
    required this.id,
    required this.name,
    required this.idWeather,
    required this.mechanic,
    required this.resistance,
    required this.teamrec,
    required this.version,
  });

  factory AbyssBossModel.fromMap(Map<String, dynamic> map) {
    return AbyssBossModel(
      id: map['id'],
      name: map['name'],
      idWeather: map['id_weather'],
      mechanic: map['mechanic'],
      resistance: map['resistance'],
      teamrec: map['abyssboss_teamrec'],
      version: map['version'],
    );
  }
}
