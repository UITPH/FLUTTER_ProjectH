class BossModel {
  final String label;
  final String id;
  final String imageName;
  final String weather;
  final String mechanics;
  final String resistance;

  BossModel({
    required this.label,
    required this.id,
    required this.imageName,
    required this.weather,
    required this.mechanics,
    required this.resistance,
  });

  factory BossModel.fromJson(Map<String, dynamic> json) {
    return BossModel(
      label: json['label'],
      id: json['id'],
      imageName: json['imageName'],
      weather: json['weather'],
      mechanics: json['mechanics'],
      resistance: json['resistance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'id': id,
      'imageName': imageName,
      'weather': weather,
      'mechanics': mechanics,
      'resistance': resistance,
    };
  }
}
