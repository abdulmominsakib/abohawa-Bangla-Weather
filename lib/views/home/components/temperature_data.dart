import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/weather_model.dart';
import '../../../providers/weather_home_provider.dart';
import '../../../constants/styling.dart';

class TemperatureData extends ConsumerWidget {
  const TemperatureData({
    super.key,
    required this.weather,
    required this.isToday,
  });

  final WeatherCondition weather;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banglaTemperature = ref
        .read(weatherHomeProvider(context).notifier)
        .convertToBanglaNumber(weather.temperature.round());
    final banglaFeelsLike = ref
        .read(weatherHomeProvider(context).notifier)
        .convertToBanglaNumber(weather.feelsLike.round());
    final height = MediaQuery.sizeOf(context).height;

    return SizedBox(
      height: height / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${isToday ? 'আজ ' : ''}তাপমাত্রাঃ', style: kBanglaFont),
          Text(
            '$banglaTemperature°',
            style: kHeaderTitle.copyWith(
                fontWeight: FontWeight.bold, fontSize: height / 13),
          ),
          SizedBox(height: 10),
          Text('অনুভূত তাপমাত্রাঃ $banglaFeelsLike°',
              style: kBanglaFont.copyWith(fontSize: height / 40)),
        ],
      ),
    );
  }
}
