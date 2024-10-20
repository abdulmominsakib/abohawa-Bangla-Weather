import 'package:flutter/material.dart';

import '../../../models/weather_model.dart';
import 'additional_info.dart';
import 'temperature_data.dart';
import 'weather_description.dart';
import 'weather_icon.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({
    super.key,
    required this.currentWeather,
    this.isToday = false,
  });

  final WeatherCondition currentWeather;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeatherDescription(weather: currentWeather),
        WeatherIcon(weather: currentWeather),
        TemperatureData(
          weather: currentWeather,
          isToday: isToday,
        ),
        AdditionalInfo(weather: currentWeather),
      ],
    );
  }
}
