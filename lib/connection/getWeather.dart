import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetWeatherData {
  // <--- Add Your Api Key Here --->
  static String apiKey = '';

  // You can get history data with this method
  // // Divided by Thousand so it can be compatiable with the API
  // var yesterDayDate =
  //     DateTime.now().add(Duration(days: -1)).toUtc().millisecondsSinceEpoch ~/
  //         1000;

  static Future getWeatherByLatLong(String lat, String lon, int dt) async {
    var url =
        'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=$lat&lon=$lon&dt=$dt&units=metric&appid=$apiKey';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else
      throw Exception('Failed to load data');
  }

  // One Call api of openweather
  static Future getWeatherForecast(String lat, String lon) async {
    var url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely,alerts&units=metric&appid=$apiKey';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else
      throw Exception('Failed to load data');
  }

  // Get Current Weather, Used for search
  static Future getWeatherByCityName(String cityName) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey';
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  // Used for zilla funcionality, Because some city doesn't have name in openweather
  static Future getCityWeatherAlt(String lat, String lon) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    var res = await http.get(url);
    return jsonDecode(res.body);
  }
}
