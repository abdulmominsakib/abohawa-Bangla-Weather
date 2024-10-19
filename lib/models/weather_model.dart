import 'dart:convert';

class WeatherCondition {
  WeatherCondition({
    required this.location,
    required this.descriptionWeather,
    this.iconWeather,
    required this.windSpeed,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.date,
  });

  final String location;
  final String descriptionWeather;
  final String? iconWeather;
  final double windSpeed;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'location': location,
      'descriptionWeather': descriptionWeather,
      'iconWeather': iconWeather,
      'windSpeed': windSpeed,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'pressure': pressure,
      'date': date.toIso8601String(),
    };
  }

  factory WeatherCondition.fromMap(Map<String, dynamic> map) {
    return WeatherCondition(
      location: map['name'] as String,
      descriptionWeather: map['weather'][0]['description'] as String,
      iconWeather: map['weather'][0]['icon'] as String,
      windSpeed: (map['wind']['speed'] as num).toDouble(),
      temperature: (map['main']['temp'] as num).toDouble(),
      feelsLike: (map['main']['feels_like'] as num).toDouble(),
      humidity: map['main']['humidity'] as int,
      pressure: map['main']['pressure'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherCondition.fromJson(String source) =>
      WeatherCondition.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WeatherCondition(location: $location, descriptionWeather: $descriptionWeather, iconWeather: $iconWeather, windSpeed: $windSpeed, temperature: $temperature, feelsLike: $feelsLike, humidity: $humidity, pressure: $pressure, date: $date)';
  }
}
