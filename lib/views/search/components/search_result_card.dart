import 'package:abohawa/extensions/extensions.dart';
import 'package:flutter/material.dart';
import '../../../models/city_model.dart';
import '../../../constants/styling.dart';

class SearchResultCard extends StatelessWidget {
  final City city;

  const SearchResultCard({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 500,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacityValue(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(city.cityName, style: kHeaderTitle.copyWith(fontSize: 35)),
          Divider(color: Colors.white10, thickness: 2),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/weather-icons/${city.iconName}.png',
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                color: Colors.white,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('এখন তাপমাত্রাঃ',
                      style: kBanglaFont.copyWith(
                          fontSize: 15, color: Colors.white)),
                  Text('${city.temperature}°', style: kHeaderTitle),
                  Text('${city.weatherDesc},',
                      style: kBanglaFont.copyWith(
                          fontSize: 18, color: Colors.white)),
                  SizedBox(height: 10),
                  Text('বাতাসের গতিঃ',
                      style: kBanglaFont.copyWith(
                          fontSize: 15, color: Colors.white)),
                  Text('${city.windSpeed} কি.মি.',
                      style: kBanglaFont.copyWith(
                          fontSize: 15, color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
