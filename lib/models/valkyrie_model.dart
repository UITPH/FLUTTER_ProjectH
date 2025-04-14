class ValkyrieModel {
  final String name;
  final String imageName;
  final int astralop;
  final int dame;
  final int type;

  ValkyrieModel({
    required this.name,
    required this.imageName,
    required this.astralop,
    required this.dame,
    required this.type,
  });

  factory ValkyrieModel.fromJson(Map<String, dynamic> json) {
    return ValkyrieModel(
      name: json['name'],
      imageName: json['imageName'],
      astralop: json['astralop'],
      dame: json['dame'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageName': imageName,
      'astralop': astralop,
      'dame': dame,
      'type': type,
    };
  }
}
