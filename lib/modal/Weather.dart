class WeatherCondition {
  WeatherCondition(
      {this.descriptionWeather,
      this.iconWeather,
      this.windSpeed,
      this.temperature,
      this.location,
      this.nightTemperature});

  final String location;
  final String descriptionWeather;
  final String iconWeather;
  final double windSpeed;
  final int temperature;
  final int nightTemperature;
}
