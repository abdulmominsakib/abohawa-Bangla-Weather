import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/weather_model.dart';
import '../../../providers/weather_home_provider.dart';
import '../../../constants/styling.dart';

class WeatherDescription extends ConsumerWidget {
  const WeatherDescription({
    super.key,
    required this.weather,
  });

  final WeatherCondition weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banglaDesc = ref
        .read(weatherHomeProvider.notifier)
        .getBanglaWeatherDesc(weather.descriptionWeather);
    return Text(banglaDesc, style: kBanglaFont);
  }
}
