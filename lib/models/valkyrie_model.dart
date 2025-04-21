class ValkyrieModel {
  final String label;
  final String id;
  final String imageName;
  final int astralop;
  final List dame;
  final int type;

  ValkyrieModel({
    required this.label,
    required this.id,
    required this.imageName,
    required this.astralop,
    required this.dame,
    required this.type,
  });

  factory ValkyrieModel.fromJson(Map<String, dynamic> json) {
    return ValkyrieModel(
      label: json['label'],
      id: json['id'],
      imageName: json['imageName'],
      astralop: json['astralop'],
      dame: json['dame'],
      type: json['type'],
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
    };
  }
}
