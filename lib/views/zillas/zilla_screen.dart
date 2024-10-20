import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/weather_service.dart';
import '../../models/city_model.dart';
import '../../utils/bd_weather_utils.dart';
import 'components/error_card.dart';
import 'components/error_message.dart';
import 'components/shimmer_zilla_card.dart';
import 'components/zilla_card.dart';

class SavedCity extends HookConsumerWidget {
  const SavedCity({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = useMemoized(() => loadCities(), []);
    final cityListSnapshot = useFuture(cities);
    final weatherProvider = ref.watch(weatherServiceProvider);
    return SafeArea(
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              'বাংলাদেশের সব জেলার বর্তমান আবহাওয়া',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 100,
              child: Divider(color: Colors.white),
            ),
            Expanded(
              child: cityListSnapshot.hasData
                  ? ListView.builder(
                      itemCount: cityListSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        final city = cityListSnapshot.data![index];
                        return FutureBuilder<City>(
                          future: getWeatherForCity(city, weatherProvider),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return ErrorCard(
                                    errorMessage: snapshot.error.toString());
                              }
                              return ZillaCard(city: snapshot.data!);
                            } else {
                              return ShimmerZillaCard();
                            }
                          },
                        );
                      },
                    )
                  : cityListSnapshot.hasError
                      ? ErrorMessage(message: cityListSnapshot.error.toString())
                      : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> loadCities() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/bangladesh_zilla_list.json');
      final List<dynamic> zillaList = json.decode(jsonString)['zilla_list'];
      return List<Map<String, dynamic>>.from(zillaList);
    } catch (e) {
      throw Exception('Failed to load cities: $e');
    }
  }

  Future<City> getWeatherForCity(
      Map<String, dynamic> city, WeatherService weatherService) async {
    try {
      final response =
          await weatherService.getWeatherByLatLong(city['lat'], city['lon']);
      return City(
        cityName: city['name'],
        temperature: response['main']['temp'].toString(),
        windSpeed: response['wind']['speed'].toString(),
        weatherDesc:
            BDWeatherUtils.getBanglaDesc(response['weather'][0]['description']),
        iconName:
            BDWeatherUtils.iconName(response['weather'][0]['description']),
      );
    } catch (e) {
      throw Exception('Failed to get weather for ${city['name']}: $e');
    }
  }
}
