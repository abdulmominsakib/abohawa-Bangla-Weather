import 'package:abohawa/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import '../utils/bd_weather_utils.dart';
import '../models/city_model.dart';

class SearchState {
  final City? searchedCity;
  final bool isLoading;
  final bool noCityAvailable;

  SearchState({
    this.searchedCity,
    this.isLoading = false,
    this.noCityAvailable = false,
  });

  SearchState copyWith({
    City? searchedCity,
    bool? isLoading,
    bool? noCityAvailable,
  }) {
    return SearchState(
      searchedCity: searchedCity ?? this.searchedCity,
      isLoading: isLoading ?? this.isLoading,
      noCityAvailable: noCityAvailable ?? this.noCityAvailable,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(SearchState());

  Future<void> searchWeather(String typedCityName) async {
    state = state.copyWith(isLoading: true, noCityAvailable: false);

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$typedCityName&appid=${AppConfig.apiKey}&units=metric'));

      if (response.statusCode == 200) {
        final cityWeather = json.decode(response.body);
        final String cityName = cityWeather['name'];
        final String weatherDescription =
            cityWeather['weather'][0]['description'];
        final int temperature = cityWeather['main']['temp'].toInt();
        final double windSpeed = cityWeather['wind']['speed'] * 3.6;

        String banglaLocation = await _getBanglaLocation(typedCityName);

        final searchedCity = City(
          cityName: banglaLocation.isNotEmpty ? banglaLocation : cityName,
          temperature: temperature.toString(),
          windSpeed: windSpeed.toStringAsFixed(1),
          weatherDesc: BDWeatherUtils.getBanglaDesc(weatherDescription),
          iconName: BDWeatherUtils.iconName(weatherDescription),
        );

        state = state.copyWith(
          searchedCity: searchedCity,
          isLoading: false,
          noCityAvailable: false,
        );
      } else {
        state = state.copyWith(isLoading: false, noCityAvailable: true);
      }
    } catch (e) {
      print(e);
      state = state.copyWith(isLoading: false, noCityAvailable: true);
    }
  }

  Future<String> _getBanglaLocation(String typedCityName) async {
    try {
      List<Location> locations = await locationFromAddress(typedCityName);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locations[0].latitude,
        locations[0].longitude,
        // localeIdentifier: 'bn_BN',
      );
      return placemarks[0].locality ?? '';
    } catch (e) {
      print(e);
      return '';
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
