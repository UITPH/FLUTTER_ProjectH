class WeatherModel {
  final String label;
  final String value;

  WeatherModel({required this.label, required this.value});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(label: json['label'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value};
  }
}
