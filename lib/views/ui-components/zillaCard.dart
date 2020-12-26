import 'package:abohawa/views/ui-components/styling.dart';
import 'package:flutter/material.dart';

class ZillaCard extends StatelessWidget {
  ZillaCard({
    @required this.iconName,
    @required this.cityName,
    @required this.cityWeather,
    @required this.cityWeatherDesc,
  });

  final String iconName;
  final String cityName;
  final String cityWeather;
  final String cityWeatherDesc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFE9F4FC),
      ),
      child: ListTile(
        leading: Text(
          '$cityWeather°',
          style: kHeaderTitle.copyWith(color: Color(0xFF03185F), fontSize: 30),
        ),
        title: Text(cityName),
        subtitle: Text('$cityWeatherDesc রয়েছে'),
        trailing: Image.asset(
          'assets/weather-icons/$iconName.png',
          color: Colors.blue,
        ),
      ),
    );
  }
}
