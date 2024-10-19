// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:abohawa/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

final dioProvider = Provider<Dio>((ref) {
  final options = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.request,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.openweathermap.org/data/2.5',
    queryParameters: {'appid': AppConfig.apiKey, 'units': 'metric'},
    validateStatus: (int? status) {
      return status != null;
      // return status != null && status >= 200 && status < 300;
    },
  ))
    ..interceptors.add(DioCacheInterceptor(options: options));
  return dio;
});

class WeatherService {
  final Dio dio;
  WeatherService({
    required this.dio,
  });

  Future<Map<String, dynamic>> getWeatherByLatLong(
      String lat, String lon) async {
    try {
      final response = await dio.get('/weather', queryParameters: {
        'lat': lat,
        'lon': lon,
        'units': 'metric',
      });

      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWeatherForecast(
      String lat, String lon) async {
    try {
      final response = await dio.get('/forecast', queryParameters: {
        'lat': lat,
        'lon': lon,
        'exclude': 'hourly,minutely,alerts',
        'units': 'metric',
      });
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getWeatherByCityName(String cityName) async {
    try {
      final response = await dio.get('/weather', queryParameters: {
        'q': cityName,
      });
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCityWeatherAlt(String lat, String lon) async {
    try {
      final response = await dio.get('/weather', queryParameters: {
        'lat': lat,
        'lon': lon,
        'units': 'metric',
      });
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 401:
          _showErrorSnackbar(
              'Invalid API Key', 'Please add your API key in the API class');
          break;
        case 429:
          _showErrorSnackbar('API Limit Exceeded',
              'Please switch to a subscription plan that meets your needs or reduce the number of API calls in accordance with the established limits.');
          break;
        case 404:
          _showErrorSnackbar(
              'Wrong City Name', 'Wrong city name, ZIP-code or city ID');
          break;
        default:
          _showErrorSnackbar('Error', 'An unexpected error occurred');
      }
    } else {
      _showErrorSnackbar(
          'Network Error', 'Please check your internet connection');
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Fluttertoast.showToast(msg: message);
  }
}

// Provider for WeatherService
final weatherServiceProvider = Provider<WeatherService>((ref) {
  final dio = ref.read(dioProvider);
  return WeatherService(dio: dio);
});
