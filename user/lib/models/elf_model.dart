class ElfModel {
  final String id;
  final String name;
  final String overview;
  final String version;

  ElfModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.version,
  });

  factory ElfModel.fromMap(Map<String, dynamic> map) {
    return ElfModel(
      id: map['id'],
      name: map['name'],
      overview: map['overview'],
      version: map['version'],
    );
  }

  Map<String, dynamic> tomap() {
    return {'id': id, 'name': name, 'overview': overview};
  }
}
