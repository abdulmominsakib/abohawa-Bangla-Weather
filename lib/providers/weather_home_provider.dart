import 'connection_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as locate;
import '../utils/bd_weather_utils.dart';
import '../models/weather_model.dart';
import '../data/weather_service.dart';

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
  HomeWeatherNotifier(this.ref) : super(WeatherState()) {
    _init();
  }

  final Ref ref;

  void _init() {
    ref.listen(connectionStatusProvider, (_, next) {
      if (next == AppConnectionStatus.online) {
        fetchCurrentWeather();
      }
    });

    // Initial fetch if online
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
      await setLocaleIdentifier('bn_BD');
      locate.Location location = locate.Location();
      await location.requestPermission();
      locate.LocationData locationData = await location.getLocation();

      String lat = locationData.latitude.toString();
      String lon = locationData.longitude.toString();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      debugPrint("Got lat: $lat, lon: $lon");

      String banglaLocation =
          placemarks[0].locality ?? placemarks[0].name ?? '';

      debugPrint('Got bangla location: $banglaLocation ');

      WeatherCondition currentWeather =
          await _getCurrentWeather(lat, lon, banglaLocation);

      debugPrint("Got current weather $currentWeather");
      final weatherService = ref.read(weatherServiceProvider);

      final forecastData = await weatherService.getWeatherForecast(lat, lon);
      final List<WeatherCondition> forecast = [];

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

      state = state.copyWith(
        currentWeather: currentWeather,
        forecast: forecast,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
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

final weatherHomeProvider =
    StateNotifierProvider<HomeWeatherNotifier, WeatherState>((ref) {
  return HomeWeatherNotifier(ref);
});
