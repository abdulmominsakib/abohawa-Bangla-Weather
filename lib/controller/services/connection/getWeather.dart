import 'dart:async';
import 'dart:convert';
import 'package:abohawa/controller/services/connection/apiKey.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetWeatherData {
  // <--- Add Your Api Key Here --->
  // You can make a class and Static function like this or You can
  // just directly put your api key in the String
  static String apiKey = ApiKey.myKey();

  // You can get history data with this method
  // // Divided by Thousand so it can be compatiable with the API
  // var yesterDayDate =
  //     DateTime.now().add(Duration(days: -1)).toUtc().millisecondsSinceEpoch ~/
  //         1000;

  static Future getWeatherByLatLong(String lat, String lon, int dt) async {
    var url =
        'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=$lat&lon=$lon&dt=$dt&units=metric&appid=$apiKey';
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        handleError(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  // One Call api of openweather
  static Future getWeatherForecast(String lat, String lon) async {
    var url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely,alerts&units=metric&appid=$apiKey';
    var response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        handleError(response.statusCode);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  // Get Current Weather, Used for search
  static Future getWeatherByCityName(String cityName) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey';
    var response = await http.get(url);
    handleError(response.statusCode);
    return jsonDecode(response.body);
  }

  // Used for zilla funcionality,
  // The reason I am using lat and lon because,
  // Because some city doesn't have name in openweather database
  static Future getCityWeatherAlt(String lat, String lon) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    var res = await http.get(url);
    handleError(res.statusCode);
    return jsonDecode(res.body);
  }
}

// Error Handling Function, This will show the error in UI
void handleError(int responseCode) {
  // You can simulate the error Here by adding the response code
  // You can learn more about the api request here:
  // https://openweathermap.org/faq#error401
  // responseCode = 404;

  if (responseCode == 401) {
    Get.showSnackbar(GetBar(
      title: 'Invalid Api Key',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blueAccent,
      message: 'Please add you api key in the Api class',
      isDismissible: true,
      icon: Icon(Icons.vpn_key),
      duration: Duration(seconds: 5),
    ));
  } else if (responseCode == 429) {
    Get.showSnackbar(GetBar(
      title: 'Api Limit Exceeded',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      message:
          '''Please switch to a subscription plan that meets your needs or reduce the number of API calls in accordance with the established limits.''',
      isDismissible: true,
      icon: Icon(Icons.https),
      duration: Duration(seconds: 5),
    ));
  } else if (responseCode == 404) {
    Get.showSnackbar(GetBar(
      title: 'Wrong City Name',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      message: 'Wrong city name, ZIP-code or city ID',
      duration: Duration(seconds: 5),
      icon: Icon(Icons.location_city),
      isDismissible: true,
    ));
  }
}
