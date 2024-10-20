import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/weather_model.dart';
import '../../../providers/weather_home_provider.dart';
import '../../../constants/styling.dart';

class AdditionalInfo extends ConsumerWidget {
  const AdditionalInfo({
    super.key,
    required this.weather,
  });

  final WeatherCondition weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banglaWindSpeed = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.windSpeed.round());
    final banglaHumidity = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.humidity);
    final banglaPressure = ref
        .read(weatherHomeProvider.notifier)
        .convertToBanglaNumber(weather.pressure);
    final height = MediaQuery.sizeOf(context).height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: height / 30),
      child: Column(
        children: [
          Text('অতিরিক্ত তথ্য',
              style: kBanglaFont.copyWith(fontSize: height / 40)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem('বাতাসের গতি', '$banglaWindSpeed কি.মি./ঘণ্টা'),
              _buildInfoItem('আর্দ্রতা', '$banglaHumidity%'),
              _buildInfoItem('চাপ', '$banglaPressure hPa'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: kBanglaFont.copyWith(fontSize: 14)),
        Text(value,
            style: kBanglaFont.copyWith(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
