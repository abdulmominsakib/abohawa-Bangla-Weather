// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:abohawa/data/weather_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/city_model.dart';
import '../utils/bd_weather_utils.dart';

class WeatherNotifier extends StateNotifier<AsyncValue<List<City>>> {
  WeatherNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadZillaWeather();
  }

  final Ref ref;

  Future<void> loadZillaWeather() async {
    try {
      state = const AsyncValue.loading();
      final String jsonString =
          await rootBundle.loadString('assets/bangladesh_zilla_list.json');
      final List<dynamic> zillaList = json.decode(jsonString)['zilla_list'];

      final weatherService = ref.read(weatherServiceProvider);
      final List<City> cities = await Future.wait(
        zillaList.map((zilla) async {
          final response = await weatherService.getWeatherByLatLong(
              zilla['lat'], zilla['lon']);
          return City(
            cityName: zilla['name'],
            temperature: response['main']['temp'].toString(),
            windSpeed: response['wind']['speed'].toString(),
            weatherDesc: BDWeatherUtils.getBanglaDesc(
                response['weather'][0]['description']),
            iconName:
                BDWeatherUtils.iconName(response['weather'][0]['description']),
          );
        }),
      );

      state = AsyncValue.data(cities);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<List<City>>>((ref) {
  return WeatherNotifier(ref);
});
