class ElfModel {
  final String name;
  final String imageName;

  ElfModel({required this.name, required this.imageName});

  factory ElfModel.fromJson(Map<String, dynamic> json) {
    return ElfModel(name: json['name'], imageName: json['imageName']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'imageName': imageName};
  }
}
