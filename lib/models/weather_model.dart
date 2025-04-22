class WeatherModel {
  final String label;
  final String value;
  final String weatherspecific;

  WeatherModel({
    required this.label,
    required this.value,
    required this.weatherspecific,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      label: json['label'],
      value: json['value'],
      weatherspecific: json['weatherspecific'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'value': value, 'weatherspecific': weatherspecific};
  }
}
