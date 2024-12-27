import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/weather_model.dart';
import '../../../providers/weather_home_provider.dart';

class WeatherIcon extends ConsumerWidget {
  const WeatherIcon({
    super.key,
    required this.weather,
  });

  final WeatherCondition weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = ref
        .read(weatherHomeProvider(context).notifier)
        .whichIconToShow(weather.descriptionWeather);
    final height = MediaQuery.sizeOf(context).height;

    return Container(
      height: height / 4.5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Image.asset(
        'assets/weather-icons/$icon.png',
        color: icon == 'clear' ? null : Colors.white,
        width: 300,
        height: height / 4,
        fit: BoxFit.contain,
      ),
    );
  }
}
