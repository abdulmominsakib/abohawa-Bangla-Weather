import 'dart:async';
import 'package:abohawa/controller/services/connection/getWeather.dart';
import 'package:abohawa/controller/services/weatherData/banglaWeatherDesc.dart';
import 'package:abohawa/controller/services/weatherData/whichIconToShow.dart';
import 'package:abohawa/modal/Weather.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locate;

class WeatherConditionController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await internetHere();
    makeWeatherList();
  }

  // This list will be used in the UI
  List<WeatherCondition> weatherList = [];

  var weatherListUpdater = List<WeatherCondition>().obs;

  // For progress bar
  var isLoading = true.obs;

  // For internet
  var isInternetAvailable = true.obs;

  internetHere() async {
    isInternetAvailable.value = await DataConnectionChecker().hasConnection;
  }

  Future<List<WeatherCondition>> makeWeatherList() async {
    if (isInternetAvailable.value == false) {
      // Do nothing
    } else if (weatherList.isEmpty) {
      // For progress indicator
      isLoading.value = true;

      // Location Service
      locate.Location location = locate.Location();
      bool _serviceEnabled;

      locate.PermissionStatus _permissionGranted;
      locate.LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == locate.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != locate.PermissionStatus.granted) {
          return null;
        }
      }

      _locationData = await location.getLocation();

      print(_locationData.latitude);
      print(_locationData.longitude);
      // For Network Call
      String lat = _locationData.latitude.toString();
      String lon = _locationData.longitude.toString();
      // For geocoding
      double lat2 = _locationData.latitude;
      double lon2 = _locationData.longitude;

      // Getting Name Of Location in Bengali
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat2, lon2, localeIdentifier: 'bn_BN');

      // print(placemarks);

      String englishLocation = placemarks[0].name;

      String banglaLocation = placemarks[0].locality == ''
          ? englishLocation
          : placemarks[0].locality;

      // print(banglaLocation);
      // print(englishLocation);

      // <--- Getting YesterDayWeather --->
      // Divided by Thousand so it can be compatiable with the API
      int dt = DateTime.now()
              .add(Duration(days: -1))
              .toUtc()
              .millisecondsSinceEpoch ~/
          1000;

      Map<String, dynamic> yesterDayWeatherData =
          await GetWeatherData.getWeatherByLatLong(lat, lon, dt);
      double yesterdayWindSpeed =
          await yesterDayWeatherData['current']['wind_speed'] * 3.6.round();
      int yesterDayTemperature =
          await yesterDayWeatherData['current']['temp'].toInt();
      String yesterDayweatherDesc =
          await yesterDayWeatherData['current']['weather'][0]['description'];

      getYesterDayWeather() {
        return WeatherCondition(
          location: banglaLocation,
          temperature: yesterDayTemperature,
          descriptionWeather: yesterDayweatherDesc,
          windSpeed: yesterdayWindSpeed,
          // The yesterDayApi doesn't have any night time data available
          nightTemperature: 0,
        );
      }

      // For All of The Other Weather Fetching
      Map<String, dynamic> foreCastWeatherData =
          await GetWeatherData.getWeatherForecast(lat, lon);
      // print(foreCastWeatherData);

      // For Current Weather
      int currentTemperature = foreCastWeatherData['current']['temp'].toInt();
      String currentDescription =
          foreCastWeatherData['current']['weather'][0]['description'];
      double currentWindSpeed =
          foreCastWeatherData['current']['wind_speed'] * 3.6.round();
      int todayNightTemperature =
          foreCastWeatherData['daily'][0]['temp']['night'].toInt();

      getCurrentWeather() {
        return WeatherCondition(
          location: banglaLocation,
          temperature: currentTemperature,
          windSpeed: currentWindSpeed,
          descriptionWeather: currentDescription,
          nightTemperature: todayNightTemperature,
        );
      }

      // Get Daily Weather Function
      getDailyWeather(int dayNumber) {
        int dayTemperature =
            foreCastWeatherData['daily'][dayNumber]['temp']['day'].toInt();
        double dayWindSpeed =
            foreCastWeatherData['daily'][dayNumber]['wind_speed'] * 3.6.round();
        String dayDescription = foreCastWeatherData['daily'][dayNumber]
            ['weather'][0]['description'];

        int nightTemperature =
            foreCastWeatherData['daily'][dayNumber]['temp']['night'].toInt();

        // print(dayDescription);
        // print(dayWindSpeed);
        // print(dayTemperature);

        return WeatherCondition(
          location: banglaLocation,
          temperature: dayTemperature,
          windSpeed: dayWindSpeed,
          descriptionWeather: dayDescription,
          nightTemperature: nightTemperature,
        );
      }

      WeatherCondition yesterDayWeather = getYesterDayWeather();
      WeatherCondition currentWeather = getCurrentWeather();
      WeatherCondition day1 = getDailyWeather(1);
      WeatherCondition day2 = getDailyWeather(2);
      WeatherCondition day3 = getDailyWeather(3);
      WeatherCondition day4 = getDailyWeather(4);
      WeatherCondition day5 = getDailyWeather(5);
      WeatherCondition day6 = getDailyWeather(6);
      WeatherCondition day7 = getDailyWeather(7);

      weatherList.addAll([
        yesterDayWeather,
        currentWeather,
        day1,
        day2,
        day3,
        day4,
        day5,
        day6,
        day7,
      ]);

      weatherListUpdater = weatherList.obs;
      isLoading.value = false;

      // To check if the list is being updated
      // print(weatherList[4].nightTemperature);
      // print(weatherList.length);
    }
    return weatherList;
  }

// <-- Bengali Weather Description -->
  getBanglaWeatherDesc(String weatherDesc) {
    return BanglaWeatherDescription.getBanglaDesc(weatherDesc);
  }

// <-- Which Icon To Show Function -->
  whichIconToShow(String weatherDesc) {
    return WhichIconToShow.iconName(weatherDesc);
  }
}
