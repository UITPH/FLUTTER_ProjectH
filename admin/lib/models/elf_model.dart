class ElfModel {
  final String id;
  final String name;
  final String overview;

  ElfModel({required this.id, required this.name, required this.overview});

  factory ElfModel.fromMap(Map<String, dynamic> map) {
    return ElfModel(
      id: map['id'],
      name: map['name'],
      overview: map['overview'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'overview': overview};
  }
}
