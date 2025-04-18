class ValkyrieModel {
  final String label;
  final String value;
  final String imageName;
  final int astralop;
  final List dame;
  final int type;

  ValkyrieModel({
    required this.label,
    required this.value,
    required this.imageName,
    required this.astralop,
    required this.dame,
    required this.type,
  });

  factory ValkyrieModel.fromJson(Map<String, dynamic> json) {
    return ValkyrieModel(
      label: json['label'],
      value: json['value'],
      imageName: json['imageName'],
      astralop: json['astralop'],
      dame: json['dame'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'imageName': imageName,
      'astralop': astralop,
      'dame': dame,
      'type': type,
    };
  }
}
