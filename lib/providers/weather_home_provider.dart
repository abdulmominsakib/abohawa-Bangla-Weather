import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../data/weather_service.dart';
import '../models/weather_model.dart';
import '../utils/bd_weather_utils.dart';
import 'connection_provider.dart';
import 'location_permission_provider.dart';

class WeatherState {
  final WeatherCondition? currentWeather;
  final bool isLoading;
  final String? error;
  final List<WeatherCondition>? forecast;

  WeatherState({
    this.currentWeather,
    this.isLoading = true,
    this.error,
    this.forecast,
  });

  WeatherState copyWith({
    WeatherCondition? currentWeather,
    bool? isLoading,
    String? error,
    List<WeatherCondition>? forecast,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      forecast: forecast ?? this.forecast,
    );
  }
}

class HomeWeatherNotifier extends StateNotifier<WeatherState> {
  HomeWeatherNotifier(this.ref, this.context) : super(WeatherState()) {
    _init();
  }

  final Ref ref;
  final BuildContext context;

  void _init() {
    ref.listen(connectionStatusProvider, (_, next) {
      if (next == AppConnectionStatus.online) {
        fetchCurrentWeather();
      }
    });

    if (ref.read(connectionStatusProvider) == AppConnectionStatus.online) {
      fetchCurrentWeather();
    }
  }

  Future<void> fetchCurrentWeather() async {
    if (ref.read(connectionStatusProvider) == AppConnectionStatus.offline) {
      state = state.copyWith(
        error: "No internet connection. Please check your network settings.",
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final permissionNotifier =
          ref.read(locationPermissionProvider(context).notifier);

      // First check and request permission
      final hasPermission =
          await permissionNotifier.checkAndRequestPermission();
      if (!hasPermission) {
        state = state.copyWith(
          error: permissionNotifier.getErrorMessage(),
          isLoading: false,
        );
        return;
      }

      // Get location data
      final locationData = await permissionNotifier.getCurrentLocation();
      if (locationData == null) {
        state = state.copyWith(
          error: "Unable to get your location. Please try again.",
          isLoading: false,
        );
        return;
      }

      // Get coordinates and location name
      final lat = locationData.latitude;
      final lon = locationData.longitude;

      if (lat == null || lon == null) {
        state = state.copyWith(
          error: "Invalid location data received. Please try again.",
          isLoading: false,
        );
        return;
      }

      // Get location name
      List<Placemark> placemarks;
      try {
        placemarks = await placemarkFromCoordinates(lat, lon);
      } catch (e) {
        debugPrint('Error getting placemark: $e');
        state = state.copyWith(
          error: "Unable to get your location name. Please try again.",
          isLoading: false,
        );
        return;
      }

      final banglaLocation = placemarks.isNotEmpty
          ? (placemarks[0].locality ?? placemarks[0].name ?? '')
          : '';

      // Get current weather
      WeatherCondition? currentWeather;
      try {
        currentWeather = await _getCurrentWeather(
          lat.toString(),
          lon.toString(),
          banglaLocation,
        );
      } catch (e) {
        debugPrint('Error getting current weather: $e');
        state = state.copyWith(
          error: "Unable to fetch current weather. Please try again.",
          isLoading: false,
        );
        return;
      }

      // Get forecast
      final List<WeatherCondition> forecast = [];
      try {
        final weatherService = ref.read(weatherServiceProvider);
        final forecastData = await weatherService.getWeatherForecast(
          lat.toString(),
          lon.toString(),
        );

        for (var i = 1; i < 8; i++) {
          final map = forecastData['list'][i];
          forecast.add(
            WeatherCondition(
              location: banglaLocation,
              descriptionWeather: map['weather'][0]['description'] as String,
              iconWeather: map['weather'][0]['icon'] as String,
              windSpeed: (map['wind']['speed'] as num).toDouble(),
              temperature: (map['main']['temp'] as num).toDouble(),
              feelsLike: (map['main']['feels_like'] as num).toDouble(),
              humidity: map['main']['humidity'] as int,
              pressure: map['main']['pressure'] as int,
              date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error getting forecast: $e');
        state = state.copyWith(
          error: "Unable to fetch weather forecast. Please try again.",
          isLoading: false,
        );
        return;
      }

      // Update state with all data
      state = state.copyWith(
        currentWeather: currentWeather,
        forecast: forecast,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Error in fetchCurrentWeather: $e');
      state = state.copyWith(
        isLoading: false,
        error: "An unexpected error occurred. Please try again.",
      );
    }
  }

  Future<WeatherCondition> _getCurrentWeather(
      String lat, String lon, String banglaLocation) async {
    final weatherService = ref.read(weatherServiceProvider);
    final map = await weatherService.getWeatherByLatLong(lat, lon);

    return WeatherCondition(
      location: banglaLocation,
      descriptionWeather: map['weather'][0]['description'] as String,
      iconWeather: map['weather'][0]['icon'] as String,
      windSpeed: (map['wind']['speed'] as num).toDouble(),
      temperature: (map['main']['temp'] as num).toDouble(),
      feelsLike: (map['main']['feels_like'] as num).toDouble(),
      humidity: map['main']['humidity'] as int,
      pressure: map['main']['pressure'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000),
    );
  }

  String getBanglaWeatherDesc(String weatherDesc) {
    return BDWeatherUtils.getBanglaDesc(weatherDesc);
  }

  String whichIconToShow(String weatherDesc) {
    return BDWeatherUtils.iconName(weatherDesc);
  }

  String convertToBanglaNumber(int numbers) {
    return BDWeatherUtils.convertToBanglaNumber(numbers.toString());
  }
}

final weatherHomeProvider = StateNotifierProvider.family<HomeWeatherNotifier,
    WeatherState, BuildContext>((ref, context) {
  return HomeWeatherNotifier(ref, context);
});
