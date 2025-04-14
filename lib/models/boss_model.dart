class BossModel {
  final String name;
  final String imageName;
  final String weather;

  BossModel({
    required this.name,
    required this.imageName,
    required this.weather,
  });

  factory BossModel.fromJson(Map<String, dynamic> json) {
    return BossModel(
      name: json['name'],
      imageName: json['imageName'],
      weather: json['weather'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'imageName': imageName, 'weather': weather};
  }
}
