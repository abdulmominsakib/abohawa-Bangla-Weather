import '../../models/city_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/bd_weather_utils.dart';

class ZillaCard extends StatelessWidget {
  const ZillaCard({
    Key? key,
    required this.city,
    this.isLoading = false,
  }) : super(key: key);

  final City? city;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading || city == null) {
      return _buildShimmerCard();
    }

    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFE9F4FC),
      ),
      child: ListTile(
        leading: Text(
          '${BDWeatherUtils.convertToBanglaNumber(city!.temperature)}°',
          style: TextStyle(
              color: Color(0xFF03185F),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        title: Text(city!.cityName),
        subtitle: Text('${city!.weatherDesc} রয়েছে'),
        trailing: Image.asset(
          'assets/weather-icons/${city!.iconName}.png',
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.all(12),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
