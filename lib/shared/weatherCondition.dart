import 'dart:async';
import 'package:bangla_utilities/bangla_utilities.dart';
import 'package:abohawa/connection/getWeather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as locate;
import 'cityObject.dart';

class WeatherCondition extends GetxController {
  WeatherCondition(
      {this.descriptionWeather,
      this.iconWeather,
      this.windSpeed,
      this.temperature,
      this.location,
      this.nightTemperature});

  final String location;
  final String descriptionWeather;
  final String iconWeather;
  final double windSpeed;
  final int temperature;
  final int nightTemperature;

  // // Divided by Thousand so it can be compatiable with the API
  int dt =
      DateTime.now().add(Duration(days: -1)).toUtc().millisecondsSinceEpoch ~/
          1000;

  List<WeatherCondition> weatherList = [];

  var weatherListUpdater = List<WeatherCondition>().obs;

  var isLoading = true.obs;

  Future<List<WeatherCondition>> makeWeatherList() async {
    print('function_started');
    print(weatherList.length);
    if (weatherList.isEmpty) {
      isLoading.value = true;

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

      String lat = _locationData.latitude.toString();
      String lon = _locationData.longitude.toString();

      double lat2 = _locationData.latitude;
      double lon2 = _locationData.longitude;

      // Getting Name Of Location in Bengali
      List<Placemark> placemarks =
          await placemarkFromCoordinates(lat2, lon2, localeIdentifier: 'bn_BN');

      // print(placemarks);

      String englishLocation = placemarks[0].name;

      // < On Ios or any other location if the locality doesn't
      // exist then a name will replace it >

      // String fullBanglaLocation =
      //     placemarks[0].locality + ',' + placemarks[0].country;

      // print(fullBanglaLocation);

      String banglaLocation = placemarks[0].locality == ''
          ? englishLocation
          : placemarks[0].locality;

      // print(banglaLocation);
      // print(englishLocation);
      // Getting YesterDayWeather

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

      // For All of The Other Getting Weather Data
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

// <-- All Zilla Weather List -->

  List<City> allZillaWeather = List<City>().obs;
  var isZillaLoading = true.obs;

  Future<List<City>> makeWeatherListZilla() async {
    isZillaLoading.value = true;
    if (allZillaWeather.isEmpty) {
      getCityWeather(String lat, String lon, String bnCityName) async {
        Map<String, dynamic> zillaWeather =
            await GetWeatherData.getCityWeatherAlt(lat, lon);

        int cityTemp = await zillaWeather['main']['temp'].toInt();
        String weatherDesc = await zillaWeather['weather'][0]['description'];

        String banglaCityTemp =
            BanglaUtility.englishToBanglaDigit(englishDigit: cityTemp);

        String iconName = whichIconToShow(weatherDesc);

        String banglaWeatherDescription = getBanglaWeatherDesc(weatherDesc);
        return City(
            cityName: '$bnCityName',
            temperature: banglaCityTemp,
            weatherDesc: banglaWeatherDescription,
            iconName: iconName);
      }

      addAllZillaToList() async {
        allZillaWeather.addAll([
          await getCityWeather('22.335109', '91.834073', 'চট্টগ্রাম'),
          await getCityWeather('23.7115253', '90.4111451', 'ঢাকা'),
          await getCityWeather('23.4682747', '91.1788135', 'কুমিল্লা'),
          await getCityWeather('23.023231', '91.3840844', 'ফেনী'),
          // await getCityWeather('23.9570904', '91.1119286', 'ব্রাহ্মণবাড়িয়া'),
          await getCityWeather('22.7324', '92.2985', 'রাঙ্গামাটি'),
          await getCityWeather('22.869563', '91.099398', 'নোয়াখালী'),
          await getCityWeather('23.2332585', '90.6712912', 'চাঁদপুর'),
          // await getCityWeather('22.94247', '90.841184', 'লক্ষ্মীপুর'),
          await getCityWeather('21.4272', '92.0058', 'কক্সবাজার'),
          await getCityWeather('23.119285', '91.984663', 'খাগড়াছড়ি'),
          await getCityWeather('21.8311', '92.3686', 'বান্দরবান'),
          // await getCityWeather('24.4533978', '89.7006815', 'সিরাজগঞ্জ'),
          await getCityWeather('23.998524', '89.233645', 'পাবনা'),
          await getCityWeather('24.8465228', '89.377755', 'বগুড়া'),
          await getCityWeather('24.3745', '88.6042', 'রাজশাহী'),
          await getCityWeather('24.420556', '89.000282', 'ঢাকা'),
          // await getCityWeather('25.0968', '89.0227', 'জয়পুরহাট'),
          // await getCityWeather('24.7413', '88.2912', 'চাঁপাইনবাবগঞ্জ'),
          // await getCityWeather('24.7936', '88.9318', 'নওগাঁ'),
          // await getCityWeather('23.1778', '89.1801', 'যশোর'),
          // await getCityWeather('22.3155', '89.1115', 'সাতক্ষীরা'),
          // await getCityWeather('23.8052', '88.6724', 'মেহেরপুর'),
          // await getCityWeather('23.1163', '89.5840', 'নড়াইল'),
          // await getCityWeather('23.6161', '88.8263', 'চুয়াডাঙ্গা'),
          // await getCityWeather('23.8907', ' 89.1099', 'কুষ্টিয়া'),
          // await getCityWeather('23.4855', '89.4198', 'মাগুরা'),
          await getCityWeather('22.8456', '89.5403', 'খুলনা'),
          // await getCityWeather('22.6602', '89.7895', 'বাগেরহাট'),
          // await getCityWeather('23.5528', '89.1754', 'ঝিনাইদহ'),
          // await getCityWeather('22.5721', '90.1870', 'ঝালকাঠি'),
          // await getCityWeather('22.3586', '90.3317', 'পটুয়াখালী'),
          await getCityWeather('22.5791', '89.9759', 'পিরোজপুর'),
          // await getCityWeather('22.7010', ' 90.3535', 'বরিশাল'),
          // await getCityWeather('22.685923', '90.648179', 'ভোলা'),
          // await getCityWeather('22.0953', '90.1121', 'বরগুনা'),
          await getCityWeather('24.8949', '91.8687', 'সিলেট'),
          // await getCityWeather('24.3095', '91.7315', 'মৌলভীবাজার'),
          // await getCityWeather('24.3840', '91.4169', 'হবিগঞ্জ'),
          // await getCityWeather('25.0667', '91.4072', 'সুনামগঞ্জ'),
          // await getCityWeather('23.9193', '90.7176', 'নরসিংদী'),
          // await getCityWeather('23.9999', '90.4203', 'গাজীপুর'),
          // await getCityWeather('23.2423', '90.4348', 'শরীয়তপুর'),
          // await getCityWeather('23.6316', '90.4974', 'নারায়ণগঞ্জ'),
          // await getCityWeather('24.2513', '89.9167', 'টাঙ্গাইল'),
          // await getCityWeather('24.4331', '90.7866', 'কিশোরগঞ্জ'),
          // await getCityWeather('23.8644', '90.0047', 'মানিকগঞ্জ'),
          // await getCityWeather('23.4981', ' 90.4127', 'মুন্সিগঞ্জ'),
          // await getCityWeather('23.7151', '89.5875', 'রাজবাড়ী'),
          // await getCityWeather('23.2393', '90.1870', 'মাদারীপুর'),
          // await getCityWeather('23.0488', '89.8879', 'গোপালগঞ্জ'),
          // await getCityWeather('23.6019', '89.8333', 'ফরিদপুর'),
          // await getCityWeather('26.3354', '88.5517', 'পঞ্চগড়'),
          // await getCityWeather('25.6217061', '88.6354504', 'দিনাজপুর'),
          // await getCityWeather('25.9923', '89.2847', 'লালমনিরহাট'),
          // await getCityWeather('25.931794', '88.856006', 'নীলফামারী'),
          // await getCityWeather('25.328751', '89.528088', 'গাইবান্ধা'),
          // await getCityWeather('26.0336945', '88.4616834', 'ঠাকুরগাঁও'),
          // await getCityWeather('25.7558096', '89.244462', 'রংপুর'),
          // await getCityWeather('25.805445', '89.636174', 'কুড়িগ্রাম'),
          // await getCityWeather('25.0204933', '90.0137', 'শেরপুর'),
          await getCityWeather('24.7471', '90.4203', 'ময়মনসিংহ'),
          // await getCityWeather('24.937533', '89.937775', 'জামালপুর'),
          // await getCityWeather('24.870955', '90.727887', 'নেত্রকোণা'),
        ]);
        isZillaLoading.value = false;
      }

      addAllZillaToList();

      return allZillaWeather;
    }
    // used for Debugging purpose
    // print(allZillaWeather.length);
    isZillaLoading.value = false;
    return allZillaWeather;
  }

// <!--- End Of All Zilla Weather Function-->

  // This function will return Bangla Weather Description
  getBanglaWeatherDesc(String weatherDesc) {
    String banglaWeatherDesc;
    // Function Goes here
    switch (weatherDesc) {

      // Follows Openweather Condition Standard

      // <-- Thunderstorm -->

      case "thunderstorm with light rain":
        {
          banglaWeatherDesc = 'হালকা বৃষ্টি সহ বজ্রপাত';
        }
        break;
      case "thunderstorm with rain":
        {
          banglaWeatherDesc = 'বৃষ্টি সহ বজ্রপাত';
        }
        break;
      case "thunderstorm with heavy rain":
        {
          banglaWeatherDesc = 'ভারী বৃষ্টি সহ ঝড়ো হাওয়া';
        }
        break;
      case "light thunderstorm":
        {
          banglaWeatherDesc = 'হালকা বজ্রপাত';
        }
        break;
      case "thunderstorm":
        {
          banglaWeatherDesc = 'বজ্রপাত';
        }
        break;
      case "heavy thunderstorm":
        {
          banglaWeatherDesc = 'ভারী বজ্রপাত';
        }
        break;
      case "ragged thunderstorm":
        {
          banglaWeatherDesc = 'কর্কশ বজ্রপাত';
        }
        break;
      case "thunderstorm with light drizzle":
        {
          banglaWeatherDesc = 'হালকা গুঁড়ি গুঁড়ি ব্রষ্টি সহ বজ্রপাত';
        }
        break;

      case "thunderstorm with drizzle":
        {
          banglaWeatherDesc = 'গুঁড়ি গুঁড়ি ব্রষ্টি সহ বজ্রপাত';
        }
        break;
      case " thunderstorm with heavy drizzle":
        {
          banglaWeatherDesc = 'ভারী ঝরঝির বৃষ্টি সহ বজ্রপাত';
        }
        break;

      // <-- Drizzle -->

      case "light intensity drizzle":
        {
          banglaWeatherDesc = 'হালকা তীব্রতা বৃষ্টি';
        }
        break;
      case "drizzle":
        {
          banglaWeatherDesc = 'ঝরঝরে বৃষ্টি';
        }
        break;
      case "heavy intensity drizzle":
        {
          banglaWeatherDesc = 'ভারী তীব্রতা বৃষ্টি';
        }
        break;
      case "light intensity drizzle rain":
        {
          banglaWeatherDesc = 'হালকা তীব্রতা বৃষ্টি বৃষ্টি';
        }
        break;
      case "drizzle rain":
        {
          banglaWeatherDesc = 'গুঁড়ি গুঁড়ি বৃষ্টি';
        }
        break;
      case "heavy intensity drizzle rain":
        {
          banglaWeatherDesc = 'ভারী এবং তীব্রতা বৃষ্টি';
        }
        break;
      case "shower rain and drizzle":
        {
          banglaWeatherDesc = 'ঝরনা বৃষ্টি এবং ঝরঝির বৃষ্টি';
        }
        break;
      case "heavy shower rain and drizzle":
        {
          banglaWeatherDesc = 'ভারী ঝরনা বৃষ্টি এবং ঝরঝির বৃষ্টি';
        }
        break;
      case "shower drizzle":
        {
          banglaWeatherDesc = 'ঝরনা বৃষ্টি';
        }
        break;

      // <-- Rain -->

      case "light rain":
        {
          banglaWeatherDesc = 'হালকা বৃষ্টি';
        }
        break;
      case "moderate rain":
        {
          banglaWeatherDesc = 'মাঝারি বৃষ্টি';
        }
        break;
      case "heavy intensity rain":
        {
          banglaWeatherDesc = '';
        }
        break;
      case "very heavy rain":
        {
          banglaWeatherDesc = 'ভারী তীব্রতা বৃষ্টি';
        }
        break;
      case "extreme rain":
        {
          banglaWeatherDesc = 'চরম বৃষ্টি';
        }
        break;
      case "freezing rain":
        {
          banglaWeatherDesc = 'হিমশীতল বৃষ্টি';
        }
        break;
      case "light intensity shower rain":
        {
          banglaWeatherDesc = 'হালকা তীব্রতা ঝরনা বৃষ্টি';
        }
        break;
      case "shower rain":
        {
          banglaWeatherDesc = 'ঝরনা বৃষ্টি';
        }
        break;
      case "heavy intensity shower rain":
        {
          banglaWeatherDesc = 'ভারী তীব্রতা ঝরনা বৃষ্টি';
        }
        break;
      case "ragged shower rain":
        {
          banglaWeatherDesc = 'কর্কশ ঝরনা বৃষ্টি';
        }
        break;

      // <-- Snow -->

      case "light snow":
        {
          banglaWeatherDesc = 'হালকা তুষারপাত';
        }
        break;
      case "snow":
        {
          banglaWeatherDesc = 'তুষার';
        }
        break;
      case "heavy snow":
        {
          banglaWeatherDesc = 'ভারি তুষারপাত';
        }
        break;
      case "Sleet":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও বৃষ্টিপাত';
        }
        break;
      case "Light shower sleet":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও হালকা বৃষ্টিপাত';
        }
        break;
      case "Shower sleet":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও ঝর্ণা বৃষ্টি';
        }
        break;
      case "Light rain and snow":
        {
          banglaWeatherDesc = 'এক সঙ্গে তুষার ও হালকা বৃষ্টি';
        }
        break;
      case "Rain and snow":
        {
          banglaWeatherDesc = 'তুষার এবং বৃষ্টি';
        }
        break;
      case "Light shower snow":
        {
          banglaWeatherDesc = 'হালকা তুষার';
        }
        break;
      case "Shower snow":
        {
          banglaWeatherDesc = 'ঝরনা তুষারপাত';
        }
        break;
      case "Heavy shower snow":
        {
          banglaWeatherDesc = 'ভারি ঝরনা তুষারপাত';
        }
        break;

      // <-- Atmosphere -->

      case "mist":
        {
          banglaWeatherDesc = 'কুয়াশা';
        }
        break;
      case "haze":
        {
          banglaWeatherDesc = 'হালকা কুয়াশা';
        }
        break;
      case "Smoke":
        {
          banglaWeatherDesc = 'ধোঁয়া';
        }
        break;
      case "sand":
        {
          banglaWeatherDesc = 'ধুলো ঘূর্ণি';
        }
        break;
      case "dust whirls":
        {
          banglaWeatherDesc = 'ধুলো ঘূর্ণি';
        }
        break;
      case "fog":
        {
          banglaWeatherDesc = 'ঘন কুয়াশা';
        }
        break;
      case "dust":
        {
          banglaWeatherDesc = 'ধূলা';
        }
        break;
      case "volcanic ash":
        {
          banglaWeatherDesc = 'আগ্নেয় ছাই';
        }
        break;
      case "squalls":
        {
          banglaWeatherDesc = 'ঝাঁকুনি';
        }
        break;
      case "tornado":
        {
          banglaWeatherDesc = 'টর্নেডো';
        }
        break;

      // <-- Clear -->

      case "clear sky":
        {
          banglaWeatherDesc = 'পরিষ্কার আকাশ';
        }
        break;

      // <-- Clouds -->

      case "few clouds":
        {
          banglaWeatherDesc = 'কিছু মেঘ';
        }
        break;
      case "scattered clouds":
        {
          banglaWeatherDesc = 'বিক্ষিপ্ত মেঘ';
        }
        break;
      case "broken clouds":
        {
          banglaWeatherDesc = 'ভাঙা মেঘ';
        }
        break;
      case "overcast clouds":
        {
          banglaWeatherDesc = 'মেঘাচ্ছন্ন মেঘ';
        }
        break;

      // <-- If Everything Fails -->
      // Then it will show the english one

      default:
        {
          banglaWeatherDesc = weatherDesc;
        }
    }
    return banglaWeatherDesc;
  }

// Which Icon To Show Function

  whichIconToShow(String weatherDesc) {
    String iconName = 'na';

    // Function Goes Here
    switch (weatherDesc) {
      // Follows Openweather Condition Standard

      // <-- Thunderstorm -->

      case "thunderstorm with light rain":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;
      case "thunderstorm with rain":
        {
          iconName = 'thunderstorm-with-heavy-rain';
        }
        break;
      case "thunderstorm with heavy rain":
        {
          iconName = 'thunderstorm-with-heavy-rain';
        }
        break;
      case "light thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "heavy thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "ragged thunderstorm":
        {
          iconName = 'thunderstorm';
        }
        break;
      case "thunderstorm with light drizzle":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;

      case "thunderstorm with drizzle":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;
      case " thunderstorm with heavy drizzle":
        {
          iconName = 'thunderstorm-with-light-rain';
        }
        break;

      // <-- Drizzle -->

      case "light intensity drizzle":
        {
          iconName = 'light-intensity-drizzle';
        }
        break;
      case "drizzle":
        {
          iconName = 'drizzle';
        }
        break;
      case "heavy intensity drizzle":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "light intensity drizzle rain":
        {
          iconName = 'light-intensity-drizzle';
        }
        break;
      case "drizzle rain":
        {
          iconName = 'drizzle-rain';
        }
        break;
      case "heavy intensity drizzle rain":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "shower rain and drizzle":
        {
          iconName = 'light-intensity-shower-rain';
        }
        break;
      case "heavy shower rain and drizzle":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "shower drizzle":
        {
          iconName = 'drizzle-rain';
        }
        break;

      // <-- Rain -->

      case "light rain":
        {
          iconName = 'light-rain';
        }
        break;
      case "moderate rain":
        {
          iconName = 'rain';
        }
        break;
      case "heavy intensity rain":
        {
          iconName = 'thunderstorm-with-heavy-rain';
        }
        break;
      case "very heavy rain":
        {
          iconName = 'rain';
        }
        break;
      case "extreme rain":
        {
          iconName = 'rain';
        }
        break;
      case "freezing rain":
        {
          iconName = 'sleet';
        }
        break;
      case "light intensity shower rain":
        {
          iconName = 'light-intensity-shower-rain';
        }
        break;
      case "shower rain":
        {
          iconName = 'showers-with-rain';
        }
        break;
      case "heavy intensity shower rain":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;
      case "ragged shower rain":
        {
          iconName = 'heavy-intensity-shower-rain';
        }
        break;

      // <-- Snow -->

      case "light snow":
        {
          iconName = 'snow';
        }
        break;
      case "snow":
        {
          iconName = 'snow';
        }
        break;
      case "heavy snow":
        {
          iconName = 'heavy-snow';
        }
        break;
      case "Sleet":
        {
          iconName = 'sleet';
        }
        break;
      case "Light shower sleet":
        {
          iconName = 'sleet';
        }
        break;
      case "Shower sleet":
        {
          iconName = 'sleet';
        }
        break;
      case "Light rain and snow":
        {
          iconName = 'sleet';
        }
        break;
      case "Rain and snow":
        {
          iconName = 'sleet';
        }
        break;
      case "Light shower snow":
        {
          iconName = 'snow';
        }
        break;
      case "Shower snow":
        {
          iconName = 'snow';
        }
        break;
      case "Heavy shower snow":
        {
          iconName = 'snow';
        }
        break;

      // <-- Atmosphere -->

      case "mist":
        {
          iconName = 'mist';
        }
        break;
      case "haze":
        {
          iconName = 'haze';
        }
        break;
      case "Smoke":
        {
          iconName = 'smoke';
        }
        break;
      case "sand":
        {
          iconName = 'dust';
        }
        break;
      case "dust whirls":
        {
          iconName = 'dust';
        }
        break;
      case "fog":
        {
          iconName = 'fog';
        }
        break;
      case "dust":
        {
          iconName = 'dust';
        }
        break;
      case "volcanic ash":
        {
          iconName = 'volcanic-ash';
        }
        break;
      case "squalls":
        {
          iconName = 'squalls';
        }
        break;
      case "tornado":
        {
          iconName = 'tornado';
        }
        break;

      // <-- Clear -->

      case "clear sky":
        {
          iconName = 'clear';
        }
        break;

      // <-- Clouds -->

      case "few clouds":
        {
          iconName = 'few-clouds';
        }
        break;
      case "scattered clouds":
        {
          iconName = 'scattered-clouds';
        }
        break;
      case "broken clouds":
        {
          iconName = 'broken-clouds';
        }
        break;
      case "overcast clouds":
        {
          iconName = 'overcast-clouds';
        }
        break;

      // <-- If Everything Fails -->
      default:
        {
          iconName = 'na';
        }
    }

    return iconName;
  }
}
