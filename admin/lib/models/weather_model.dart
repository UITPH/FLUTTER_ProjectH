class WeatherModel {
  final String id;
  final String name;
  final String specific;

  WeatherModel({required this.id, required this.name, required this.specific});

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      id: map['id'],
      name: map['name'],
      specific: map['specific'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'specific': specific};
  }
}
