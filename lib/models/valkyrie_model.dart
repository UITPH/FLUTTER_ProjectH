class ValkyrieModel {
  final String label;
  final String id;
  final String imageName;
  final int astralop;
  final List<dynamic> dame;
  final int type;
  final List<dynamic> lineup;
  final List<dynamic> equip;

  ValkyrieModel({
    required this.label,
    required this.id,
    required this.imageName,
    required this.astralop,
    required this.dame,
    required this.type,
    required this.lineup,
    required this.equip,
  });

  factory ValkyrieModel.fromJson(Map<String, dynamic> json) {
    return ValkyrieModel(
      label: json['label'],
      id: json['id'],
      imageName: json['imageName'],
      astralop: json['astralop'],
      dame: json['dame'],
      type: json['type'],
      lineup: json['lineup'],
      equip: json['equip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'id': id,
      'imageName': imageName,
      'astralop': astralop,
      'dame': dame,
      'type': type,
      'lineup': lineup,
      'equip': equip,
    };
  }
}
